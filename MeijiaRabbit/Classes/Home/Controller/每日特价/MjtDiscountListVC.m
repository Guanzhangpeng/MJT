//
//  MjtDiscountListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/16.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtDiscountListVC.h"
#import "MjtDiscountCell.h"
#import "MjtServiceListVC.h"
@interface MjtDiscountListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MjtDiscountListVC
static NSString *cellID = @"MjtDiscountCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.title = @"特价产品";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
    
}
- (void)_setupSubviews{
    [self _setupTableView];
}

- (void)_setupTableView{
    [self.view addSubview:self.tableView];
}
#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MjtDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cartButtonAction = ^{
        MJTLog(@"点击加入购物车--%ld",indexPath.row);
    };
    return cell;
}
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[MjtServiceListVC new] animated:YES];
}
#pragma mark -- 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.backgroundColor = MJTGlobalGrayBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 150;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtDiscountCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}
@end
