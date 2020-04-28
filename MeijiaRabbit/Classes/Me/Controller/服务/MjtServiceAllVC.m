//
//  MjtServiceAllVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceAllVC.h"
#import "MjtServiceCell.h"
#import "MjtServiceCell.h"
@interface MjtServiceBaseVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation MjtServiceBaseVC
static NSString *cellID = @"ServiceID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    
}
- (void)_setupSubviews{
    [self _setupTableview];
}
- (void)_setupTableview{
    [self.view addSubview:self.tableview];
}
#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MjtServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- 懒加载
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT - 44) style:UITableViewStylePlain];
        _tableview.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 135;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MjtServiceCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    }
    return _tableview;
}
@end

@implementation MjtServiceAllVC
-(MJTServiceOrderType)orderType{
    return MJTServiceOrderTypeAll;
}
@end

@implementation MjtServicePayingVC
-(MJTServiceOrderType)orderType{
    return MJTServiceOrderTypePaying;
}
@end

@implementation MjtServiceWorkingVC
-(MJTServiceOrderType)orderType{
    return MJTServiceOrderTypeWorking;
}
@end

@implementation MjtServiceCheckingVC
-(MJTServiceOrderType)orderType{
    return MJTServiceOrderTypeChecking;
}
@end

@implementation MjtServicePricingVC
-(MJTServiceOrderType)orderType{
    return MJTServiceOrderTypePricing;
}
@end
