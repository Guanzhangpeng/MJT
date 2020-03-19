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
@interface MjtAddressListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YWAddressInfoModel *>* dataSource;
@end

@implementation MjtAddressListVC
static NSString *cellID = @"addressID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    
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
#pragma mark -- 点击事件
- (void)_addAddress{
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    // 保存后的地址回调
    addressVC.addressBlock = ^(YWAddressInfoModel *model) {
        NSLog(@"用户地址信息填写回调：");
        NSLog(@"姓名：%@", model.nameStr);
        NSLog(@"电话：%@", model.phoneStr);
        NSLog(@"地区：%@", model.areaAddress);
        NSLog(@"详细地址：%@", model.detailAddress);
        NSLog(@"是否设为默认：%@", model.isDefaultAddress ? @"是" : @"不是");
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
    cell.editAddressAction = ^{
        YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
        addressVC.model = addressModel;
        // 保存后的地址回调
        addressVC.addressBlock = ^(YWAddressInfoModel *model) {
            NSLog(@"用户地址信息填写回调：");
            NSLog(@"姓名：%@", model.nameStr);
            NSLog(@"电话：%@", model.phoneStr);
            NSLog(@"地区：%@", model.areaAddress);
            NSLog(@"详细地址：%@", model.detailAddress);
            NSLog(@"是否设为默认：%@", model.isDefaultAddress ? @"是" : @"不是");
        };
        [self.navigationController pushViewController:addressVC animated:YES];
    };
//    cell.backgroundColor = MJTRandomColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - TableView代理方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:0 title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除---索引:%ld",indexPath.row);
    }];
    action.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:0 title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"默认---索引:%ld",indexPath.row);
    }];
    action1.backgroundColor = [UIColor lightGrayColor];
    

    
    return @[action,action1];
}
#pragma mark -- 懒加载
-(NSMutableArray<YWAddressInfoModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        YWAddressInfoModel *model1 = [[YWAddressInfoModel alloc] init];
        model1.nameStr = @"张三";
        model1.phoneStr = @"156****8833";
        model1.areaAddress = @"广东省 汕头市 潮阳区 海门镇";
        model1.detailAddress = @"北京市朝阳区惠新里3号楼Azuo201室 北京速通网电子商务有限公司";
        
        YWAddressInfoModel *model2 = [[YWAddressInfoModel alloc] init];
        model2.nameStr = @"李四";
        model2.phoneStr = @"156****8833";
        model2.areaAddress = @"新疆维吾尔自治区阿拉善大沙漠中朝阳区惠新里3号楼Azuo201室 北京速通网电子商务有限公司";
        
        YWAddressInfoModel *model3 = [[YWAddressInfoModel alloc] init];
        model3.nameStr = @"王五";
        model3.phoneStr = @"156****8833";
        model3.areaAddress = @"北京市朝阳区惠新里3号楼Azuo201室 北京速通网电子商务有限公司";
        
        YWAddressInfoModel *model4 = [[YWAddressInfoModel alloc] init];
        model4.nameStr = @"麻溜";
        model4.phoneStr = @"156****8833";
        model4.areaAddress = @"北京市朝阳区惠新里3号楼Azuo201室 北京速通网电子商务有限公司";
        
        [_dataSource addObjectsFromArray:@[model1,model2,model3,model4]];
    }
    return _dataSource;
}
@end
