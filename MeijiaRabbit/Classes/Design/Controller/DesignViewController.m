//
//  DesignViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "DesignViewController.h"
#import "MjtDesignCell.h"
#import "MjtWebView.h"
@interface DesignViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
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
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MjtDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataSource[indexPath.row];
    cell.thumbAction = ^{
        MJTLog(@"点赞--%ld",indexPath.row);
    };
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MjtWebView *webView = [[MjtWebView alloc] init];
    NSMutableDictionary *dict = self.dataSource[indexPath.row];
    webView.urlString = dict[@"urlString"];
    webView.title = dict[@"title"];
     [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[@"title"] = @"两房改三房的幸福生活";
        dic1[@"rooms"] = @"三居";
        dic1[@"style"] = @"现代";
        dic1[@"price"] = @"30万";
        dic1[@"corverImg"] = @"design1";
        dic1[@"urlString"] = @"http://192.168.8.174/case/case1.html";
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[@"title"] = @"隐世雅居 | 轻奢";
        dic2[@"rooms"] = @"三居";
        dic2[@"style"] = @"轻奢";
        dic2[@"price"] = @"30万";
        dic2[@"corverImg"] = @"design2";
        dic2[@"urlString"] = @"http://192.168.8.174/case/case2.html";
        
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
        dic3[@"title"] = @"套内80平米改造小三房！";
        dic3[@"rooms"] = @"3室2厅";
        dic3[@"style"] = @"现代";
        dic3[@"price"] = @"20万";
        dic3[@"corverImg"] = @"design3";
        dic3[@"urlString"] = @"http://192.168.8.174/case/case3.html";
        
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
        dic4[@"title"] = @"北欧风格";
        dic4[@"rooms"] = @"三居";
        dic4[@"style"] = @"现代";
        dic4[@"price"] = @"未知";
        dic4[@"corverImg"] = @"design4";
        dic4[@"urlString"] = @"http://192.168.8.174/case/case4.html";
        
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
        dic5[@"title"] = @"远山";
        dic5[@"rooms"] = @"三居";
        dic5[@"style"] = @"现代";
        dic5[@"price"] = @"30万以上";
        dic5[@"corverImg"] = @"design5";
        dic5[@"urlString"] = @"http://192.168.8.174/case/case5.html";
        
        NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
        dic6[@"title"] = @"橘色物语";
        dic6[@"rooms"] = @"三居";
        dic6[@"style"] = @"现代";
        dic6[@"price"] = @"5-10万";
        dic6[@"corverImg"] = @"design6";
        dic6[@"urlString"] = @"http://192.168.8.174/case/case6.html";
        
        NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
        dic7[@"title"] = @"简约风，保质期的新鲜~";
        dic7[@"rooms"] = @"三居";
        dic7[@"style"] = @"现代";
        dic7[@"price"] = @"20-30万";
        dic7[@"corverImg"] = @"design7";
        dic7[@"urlString"] = @"http://192.168.8.174/case/case7.html";
        
        NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
        dic8[@"title"] = @"纯水岸东湖中式风格";
        dic8[@"rooms"] = @"三居";
        dic8[@"style"] = @"现代";
        dic8[@"price"] = @"未知";
        dic8[@"corverImg"] = @"design8";
        dic8[@"urlString"] = @"http://192.168.8.174/case/case8.html";
        
        NSMutableDictionary *dic9 = [NSMutableDictionary dictionary];
        dic9[@"title"] = @"蜜 雅 糯 粉";
        dic9[@"rooms"] = @"两居";
        dic9[@"style"] = @"现代";
        dic9[@"price"] = @"30万";
        dic9[@"corverImg"] = @"design9";
        dic9[@"urlString"] = @"http://192.168.8.174/case/case9.html";
        [_dataSource addObjectsFromArray:@[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9]];
    }
    return _dataSource;
}
@end
