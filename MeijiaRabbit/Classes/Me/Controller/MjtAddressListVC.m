//
//  MjtAddressListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/18.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtAddressListVC.h"
#import "YWAddressViewController.h"
@interface MjtAddressListVC ()

@end

@implementation MjtAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupUI];
    
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地址管理";
}
- (void)_setupUI{
    [self _setupNavigation];
}
- (void)_setupNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(_addAddress)];
     
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
@end
