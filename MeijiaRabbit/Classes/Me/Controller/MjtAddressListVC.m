//
//  MjtAddressListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/18.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtAddressListVC.h"
#import "YWAddressViewController.h"
#import "MjtAddressCell.h"
#import "YWAddressInfoModel.h"
#import "MJExtension.h"
@interface MjtAddressListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *defaultIndexPath;//用于记录默认地址行号
@property (nonatomic, strong) NSMutableArray<YWAddressInfoModel *>* dataSource;
@end

@implementation MjtAddressListVC
static NSString *cellID = @"addressID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    [self _loadData];
    
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地址管理";
}
- (void)_setupSubviews{
    [self _setupNavigation];
    [self _setupTableView];
}
- (void)_setupNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(_addAddress)];
     
}
- (void)_setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MjtAddressCell class] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (void)_loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = [MjtUserInfo sharedUser].ID;
    [NetBaseTool postWithUrl:MJT_ADDRESSLIST_PATH params:param decryptResponse:NO showHud:YES success:^(id responseDict) {
        if ([responseDict[@"status"] intValue] == 200) {
            self.dataSource = [YWAddressInfoModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)_addressDefaultOrDelete:(NSString *)defaultOrDelete indexPath:(NSIndexPath *)indexPath{

    YWAddressInfoModel *model = self.dataSource[indexPath.row];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = [MjtUserInfo sharedUser].ID;
    param[@"type"] = defaultOrDelete ;  //类型(1：用户设置默认地址，2：用户删除地址)
    param[@"id"] = model.ID;//用户地址id
    if ([defaultOrDelete isEqualToString:@"1"]) {
        //如果已经是默认地址 则不用继续操作 直接返回;
        if (self.defaultIndexPath == indexPath) {
            return;
        }
        self.dataSource[self.defaultIndexPath.row].default_address = @"2";//将原先的默认地址状态取消;
        model.default_address = @"1";
        param[@"default_address"] = @"1"; //是否设默认地址（1：是，2：否）（用户设置默认地址必传）
    }
    [NetBaseTool postWithUrl:MJT_ADDRESSOPERATION_PATH params:param decryptResponse:YES showHud:NO success:^(id responseDict) {
        if ([responseDict[@"status"] intValue] == 200) {
            if ([defaultOrDelete isEqualToString:@"2"]) {
                [self.dataSource removeObjectAtIndex:indexPath.row];
            }
            self.defaultIndexPath = indexPath;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 点击事件
- (void)_addAddress{
    WeakSelf;
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    // 保存后的地址回调
    addressVC.addressBlock = ^(YWAddressInfoModel *model) {
        [weakSelf _loadData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MjtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    YWAddressInfoModel *addressModel = self.dataSource[indexPath.row];
    cell.model = addressModel;
    
    WeakSelf;
    cell.defaultAddressBlock = ^{
        weakSelf.defaultIndexPath = indexPath;
    };
    cell.editAddressAction = ^{
        YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
        addressVC.model = addressModel;
        addressVC.isEditing = YES;
        addressVC.titleIDMarr = [[NSMutableArray alloc] initWithObjects:addressModel.province_code,addressModel.city_code,addressModel.area_code,addressModel.street_code, nil];
        // 保存后的地址回调
        addressVC.addressBlock = ^(YWAddressInfoModel *model) {
           [weakSelf _loadData];
        };
        [self.navigationController pushViewController:addressVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - TableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWAddressInfoModel *addressModel = self.dataSource[indexPath.row];
    if (self.choseAction) {
        self.choseAction(addressModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:0 title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除---索引:%ld",indexPath.row);
        [self _addressDefaultOrDelete:@"2" indexPath:indexPath];
    }];
    action.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:0 title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"默认---索引:%ld",indexPath.row);
         [self _addressDefaultOrDelete:@"1" indexPath:indexPath];
    }];
    action1.backgroundColor = [UIColor lightGrayColor];
    

    
    return @[action,action1];
}
#pragma mark -- 懒加载
-(NSMutableArray<YWAddressInfoModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
