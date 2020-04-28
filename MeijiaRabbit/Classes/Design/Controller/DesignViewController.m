//
//  DesignViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "DesignViewController.h"
#import "MjtDesignCell.h"

@interface DesignViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DesignViewController
static NSString *cellID = @"DesignCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
}
- (void)_setupSubviews{
    [self _setupTableView];
}
- (void)_setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0 );
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 220;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtDesignCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MjtDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.thumbAction = ^{
        MJTLog(@"点赞--%ld",indexPath.row);
    };
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
