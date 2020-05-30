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
        
        NSMutableDictionary *dic10 = [NSMutableDictionary dictionary];
        dic10[@"title"] = @"简中式-北京设计";
        dic10[@"rooms"] = @"三居";
        dic10[@"style"] = @"中式";
        dic10[@"price"] = @"20-30万";
        dic10[@"corverImg"] = @"design10";
        dic10[@"urlString"] = @"http://192.168.8.174/case/case10.html";
        
        NSMutableDictionary *dic11 = [NSMutableDictionary dictionary];
        dic11[@"title"] = @"高级灰住宅里的一抹暖意";
        dic11[@"rooms"] = @"四居";
        dic11[@"style"] = @"现代";
        dic11[@"price"] = @"30万以上";
        dic11[@"corverImg"] = @"design11";
        dic11[@"urlString"] = @"http://192.168.8.174/case/case11.html";
        
        NSMutableDictionary *dic12 = [NSMutableDictionary dictionary];
        dic12[@"title"] = @"蔓延的中式暖意";
        dic12[@"rooms"] = @"三居";
        dic12[@"style"] = @"中式";
        dic12[@"price"] = @"30万以上";
        dic12[@"corverImg"] = @"design12";
        dic12[@"urlString"] = @"http://192.168.8.174/case/case12.html";
        
        NSMutableDictionary *dic13 = [NSMutableDictionary dictionary];
        dic13[@"title"] = @"混搭——都市重金属";
        dic13[@"rooms"] = @"四居";
        dic13[@"style"] = @"现代";
        dic13[@"price"] = @"30万以上";
        dic13[@"corverImg"] = @"design13";
        dic13[@"urlString"] = @"http://192.168.8.174/case/case13.html";
        
        NSMutableDictionary *dic14 = [NSMutableDictionary dictionary];
        dic14[@"title"] = @"新竹猫屋";
        dic14[@"rooms"] = @"四居";
        dic14[@"style"] = @"现代";
        dic14[@"price"] = @"30万以上";
        dic14[@"corverImg"] = @"design14";
        dic14[@"urlString"] = @"http://192.168.8.174/case/case14.html";
        
        NSMutableDictionary *dic15 = [NSMutableDictionary dictionary];
        dic15[@"title"] = @"拥有众多花园的办公空间";
        dic15[@"rooms"] = @"办公室";
        dic15[@"style"] = @"现代";
        dic15[@"price"] = @"3万以上";
        dic15[@"corverImg"] = @"design15";
        dic15[@"urlString"] = @"http://192.168.8.174/case/case15.html";
        
        
        
        [_dataSource addObjectsFromArray:@[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9,dic10,dic11,dic12,dic13,dic14,dic15]];
        
    }
    return _dataSource;
}
@end
