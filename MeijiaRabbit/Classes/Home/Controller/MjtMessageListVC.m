//
//  MjtMessageListVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageListVC.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MjtMessageModel.h"
#import "MjtMessageCell.h"
#import "MjtMessageDetailVC.h"
@interface MjtMessageListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<MjtMessageModel *> *dataSource;
@property (nonatomic, strong) NSIndexPath *deleteIndexpath;
@end

@implementation MjtMessageListVC
static NSString *CellID = @"MjtMessageCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.title = @"消息中心";
    self.noDataImgName=@"message_empty";
    self.isShowEmptyData = true;
}
-(void)setMessageType:(MJTMessageType)messageType{
    _messageType = messageType;
}
- (void)_setupSubviews{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0.f, 0.f, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT - 40);
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.estimatedRowHeight = 165;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtMessageCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
       self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
       [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
}
- (void)_loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"1";//类型1：消息列表，2：消息详情，3：删除
    param[@"message_type"] = [NSString stringWithFormat:@"%lu",(unsigned long)self.messageType];
    MJTLog(@"消息类型==================%ld",self.messageType);
    [NetBaseTool postWithUrl:MJT_MESSAGE_PATH params:param decryptResponse:NO showHud:NO success:^(id responseDict) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDict[@"status"] intValue] == 200) {
            self.dataSource = [MjtMessageModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)_loadNewData{
    [self _loadData];
}
- (void)_loadMoreData{
    [self _loadData];
}

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        CGPoint location = [longRecognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        self.deleteIndexpath=indexPath;
        MjtMessageCell *cell = (MjtMessageCell *)longRecognizer.view;
        [self becomeFirstResponder];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        UIMenuItem *feedBackItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(DeleteItemClicked:)];
        [menu setMenuItems:[NSArray arrayWithObjects:feedBackItem,nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MjtMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    MjtMessageModel *messageModel =  self.dataSource[indexPath.row];
    MjtMessageDetailVC *detailVC = [[MjtMessageDetailVC alloc] init];
    detailVC.message = messageModel;
    detailVC.readAction = ^{
        messageModel.isread = 1;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADMESSAGE" object:nil];
//        !weakSelf.messageReadAction ?  : weakSelf.messageReadAction();
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark -- 懒加载
-(NSMutableArray<MjtMessageModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark method
-(void)DeleteItemClicked:(id)sender
{
    MjtMessageModel * model=self.dataSource[self.deleteIndexpath.row];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"3";//类型1：消息列表，2：消息详情，3：删除
    param[@"message_type"] = [NSString stringWithFormat:@"%lu",(unsigned long)self.messageType];
    param[@"msgid"] = model.ID;
    
    MJTLog(@"消息类型==================%ld",self.messageType);
    [NetBaseTool postWithUrl:MJT_MESSAGE_PATH params:param decryptResponse:YES showHud:NO success:^(id responseDict) {
        if ([responseDict[@"status"] intValue] == 200) {
           [self.dataSource removeObjectAtIndex:self.deleteIndexpath.row];
           [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
// 用于UIMenuController显示，缺一不可
-(BOOL)canBecomeFirstResponder{
    return YES;
}
// 用于UIMenuController显示，缺一不可
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action ==@selector(DeleteItemClicked:)){
        return YES;
    }
    return NO;//隐藏系统默认的菜单项
}


@end
