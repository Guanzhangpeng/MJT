//
//  MjtUserInfoEditVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/27.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtUserInfoEditVC.h"
#import "MjtSettingSectionModel.h"
#import "MjtSettingItemModel.h"
#import "MjtSettingCell.h"
#import "TZImagePickerController.h"
#import "MjtEditVC.h"
#import "MjtNavigationController.h"
#import "UIImageView+WebCache.h"
#import "NSString+YYAdd.h"
@interface MjtUserInfoEditVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<MjtSettingSectionModel *>  *sectionArray; /**< section模型数组*/
@end

@implementation MjtUserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    [self _setupData];
}
- (void)_setup{
    self.title = @"编辑个人资料";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
- (void)_setupSubviews{
    [self _setupTableView];
}

- (void)_setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)_setupData{

    
   MjtUserInfo *userInfo =  [MjtUserInfo sharedUser];
    MjtSettingItemModel *item1 = [[MjtSettingItemModel alloc] init];
    item1.funcName = @"头像";
    item1.detailImage = [UIImage imageNamed:@"me_avatar"];
    item1.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    WeakSelf;
    item1.executeCode = ^{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
        imagePickerVc.maxImagesCount = 1;
        imagePickerVc.allowTakeVideo = NO;

        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            UIImage *avatarImg = photos[0];
            [weakSelf _editAvatar:avatarImg];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    };

    MjtSettingItemModel *item2 = [[MjtSettingItemModel alloc] init];
    item2.funcName = @"昵称";
    item2.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    item2.detailText = ([userInfo.user_name isEqualToString:@""] || userInfo.user_name == nil) ? @"未设置" : userInfo.user_name;
    __weak typeof(item2) weakItem = item2;
    item2.executeCode = ^{
        MjtEditVC *editVC = [[MjtEditVC alloc] init];
        editVC.editAction = ^(NSString * _Nonnull editInfo) {
            weakItem.detailText = editInfo;
            [weakSelf.tableView reloadData];
            !weakSelf.nickNameAction ? :weakSelf.nickNameAction(editInfo);
        };
        editVC.title = @"设置昵称";
        MjtNavigationController *nav = [[MjtNavigationController alloc] initWithRootViewController:editVC];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };

    MjtSettingItemModel *item3 = [[MjtSettingItemModel alloc] init];
    item3.funcName = @"性别";
    item3.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    item3.detailText = ([userInfo.sex isEqualToString:@""]||userInfo.sex == nil) ? @"未设置" : userInfo.sex;
    
    MjtSettingItemModel *item4 = [[MjtSettingItemModel alloc] init];
    item4.funcName = @"个性签名";
    item4.accessoryType = MJTSettingAccessoryTypeNone;
    item4.detailText = @"您的房子我来装";

    MjtSettingSectionModel *sectionItem = [[MjtSettingSectionModel alloc] init];
    sectionItem.itemArray = @[item1,item2,item3,item4];
    self.sectionArray = @[sectionItem];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MjtSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    MjtSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MjtSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    MjtSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MjtSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = itemModel;
    if (indexPath.row == 0) {
        cell.detailImageView.frame = CGRectMake(ScreenWidth - 70 - 40, 5, 60, 60);
        cell.detailImageView.layer.cornerRadius = 8;
        cell.detailImageView.layer.masksToBounds = YES;
        NSString *avatarPath = [MjtUserInfo sharedUser].avatar;
        [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:avatarPath]];
    }
    return cell;
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MjtSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MjtSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MjtSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MjtSettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;

    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark -- 点击事件
- (void)_logoutAction{
    
}
- (void)_editAvatar:(UIImage *)avatarImg{
    NSData *avatarData = UIImagePNGRepresentation(avatarImg);
    WeakSelf;
    [NetBaseTool postWithUrl:MJT_EditAVATAR_PATH params:nil data:avatarData paramName:@"file" fileName:@"avatar.jpg" mimeType:@"image/jpeg" success:^(id responseObj) {
        if ([responseObj[@"status"] intValue] == 200) {
            NSString *file_path = responseObj[@"file_path"];
            [MjtUserInfo sharedUser].avatar = file_path;
            [MjtUserInfo saveDataToKeyChian];
            !weakSelf.avatarAction ? :weakSelf.avatarAction(file_path);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0 ];
            MjtSettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:file_path]];
        }
    } failure:^(NSError *error) {

    }];
}
@end
