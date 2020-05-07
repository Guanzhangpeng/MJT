//
//  MjtMessageListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageListVC.h"

@interface MjtMessageListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * messageArray;
@end

@implementation MjtMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataImgName=@"message_empty";
    self.isShowEmptyData = true;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0.f, 0.f, ScreenWidth, ScreenHeight);
    self.tableView.estimatedRowHeight = 165;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark -- 懒加载
-(NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
@end
