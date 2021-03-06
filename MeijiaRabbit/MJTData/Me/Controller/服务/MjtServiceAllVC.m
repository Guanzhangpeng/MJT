//
//  MjtServiceAllVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceAllVC.h"
#import "MjtServiceCell.h"
#import "MJRefresh.h"
#import "MjtServiceModel.h"
#import "MJExtension.h"
#import "MjtWebView.h"
#import "DES3Util.h"
#import "RSAUtil.h"
#import "NSDictionary+YYAdd.h"
#import "NSString+Extension.h"
#import "NSString+YYAdd.h"
#import "MjtSignHelper.h"
#import "NSString+YYAdd.h"
@interface MjtServiceBaseVC ()<UITableViewDataSource,UITableViewDelegate>{
    int page;
    int count;
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray<MjtServiceModel *> *dataSource;
@end

@implementation MjtServiceBaseVC
static NSString *cellID = @"ServiceID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
-(void)setOrderType:(MJTServiceOrderType)orderType{
    _orderType = orderType;
}

- (void)_setup{
    page = 1;
    count = 10;
}
- (void)_setupSubviews{
    [self _setupTableview];
}
- (void)_setupTableview{
    [self.view addSubview:self.tableview];
}
- (void)_loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = [MjtUserInfo sharedUser].ID;
    param[@"get_type"] = [NSString stringWithFormat:@"%lu",(unsigned long)self.orderType];//获取类型(1:全部，2：待付款，3：待开工，4：待验收，5：待评价)
    MJTLog(@"==================%ld",self.orderType);
    [NetBaseTool postWithUrl:MJT_SERVICEORDER_LIST_PATH params:param decryptResponse:NO showHud:NO success:^(id responseDict) {
        [self.tableview.mj_header endRefreshing];
        if ([responseDict[@"status"] intValue] == 200) {
            self.dataSource = [MjtServiceModel mj_objectArrayWithKeyValuesArray:responseDict[@"data"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
}
- (void)_loadNewData{
    [self _loadData];
}
- (void)_loadMoreData{
    
}
#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MjtServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    MjtWebView *webView = [[MjtWebView alloc] init];
    MjtServiceModel * model = self.dataSource[indexPath.row];
    webView.showPhotoBrowser = @"YES";
    webView.urlString = [NSString stringWithFormat:@"%@?service_order_id=%@&userid=%@&mobile=%@",KURL(MJT_ORDERHANDLE_PATH),model.orderid,[MjtUserInfo sharedUser].ID,[MjtUserInfo sharedUser].mobile];
    webView.title = @"详情";
    webView.isShowClose = @"NO";
    webView.payAction = ^{
        [weakSelf _loadData];
    };
    [self.navigationController pushViewController:webView animated:YES];
}
//生成八位随机字符串
- (NSString *)randomString {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:8];
    free(characters);
    return result;
}
#pragma mark -- 懒加载
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT - 44) style:UITableViewStylePlain];
        _tableview.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 135;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MjtServiceCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
//        _tableview.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
        [_tableview.mj_header beginRefreshing];
    }
    return _tableview;
}
@end
