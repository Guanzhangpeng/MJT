//
//  MjtSettingVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtSettingVC.h"
#import "MjtSettingItemModel.h"
#import "MjtSettingSectionModel.h"
#import "MjtSettingCell.h"
#import "MjtBaseButton.h"
#import "SPAlertController.h"
#import "MjtTabBarController.h"
@interface MjtSettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@end

@implementation MjtSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupUI];
    [self _setupSubViews];
    [self _setupData];
}
- (void)_setupUI{
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)_setupSubViews{
    [self _setupTableView];
}

- (void)_setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //退出登录
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 85)];
    MjtBaseButton *logoutBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:MJTColorFromHexString(@"#000000") forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    logoutBtn.backgroundColor = MJTGlobalMainColor;
    logoutBtn.layer.cornerRadius = 10;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(_logoutAction) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.frame = CGRectMake(20, 40, ScreenWidth - 40, 45);
    [footerView addSubview:logoutBtn];
    self.tableView.tableFooterView = footerView;
}

- (void)_setupData{
    MjtSettingItemModel *item1 = [[MjtSettingItemModel alloc] init];
    item1.funcName = @"个人资料";
    item1.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    
    MjtSettingItemModel *item2 = [[MjtSettingItemModel alloc] init];
    item2.funcName = @"关于美嘉兔";
    item2.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    
    MjtSettingItemModel *item3 = [[MjtSettingItemModel alloc] init];
    item3.funcName = @"当前版本";
    /**获取程序的版本号*/
     NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    item3.detailText = [NSString stringWithFormat:@"V%@",version];
    
    MjtSettingItemModel *item4 = [[MjtSettingItemModel alloc] init];
    item4.funcName = @"清除缓存";
    item4.accessoryType = MJTSettingAccessoryTypeNone;
    item4.detailText = @"120M";
    
    MjtSettingSectionModel *sectionItem = [[MjtSettingSectionModel alloc] init];
    sectionItem.itemArray = @[item2,item3,item4];
    self.sectionArray = @[sectionItem];
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
    return cell;
}

#pragma mark - Table view delegate
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出登录?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MjtUserInfo destroyUser];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MjtTabBarController alloc] init];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
@end
