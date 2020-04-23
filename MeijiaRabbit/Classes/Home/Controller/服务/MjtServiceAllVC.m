//
//  MjtServiceAllVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceAllVC.h"
#import "MjtServiceCell.h"
@interface MjtServiceAllVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation MjtServiceAllVC
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
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
#pragma mark -- 懒加载
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MjtServiceCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    }
    return _tableview;
}
@end
