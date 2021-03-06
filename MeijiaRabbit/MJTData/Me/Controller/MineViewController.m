//
//  MineViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//
#define kAppViewW 60
#define kAppViewH 60
#define kColCount 5
#define kMarginX (ScreenWidth - kColCount * kAppViewW-kStartX*2) / (kColCount - 1)
#define kStartY   0
#define kStartX   20

#import "MineViewController.h"
#import "Masonry.h"
#import "MjtButton.h"
#import "MjtSettingVC.h"
#import "MjtSettingCell.h"
#import "MjtSettingItemModel.h"
#import "MjtSettingSectionModel.h"
#import "MjtAddressListVC.h"
#import "Masonry.h"
#import "MjtUserInfoEditVC.h"
#import "MjtServiceListVC.h"
#import "UIImageView+WebCache.h"
#import "MjtWebView.h"
#import "MjtShopReadModel.h"
#import "MJExtension.h"
#import "YeeBadgeViewHeader.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *homeArray;
@property (nonatomic, weak) UIView *userView;
@property (nonatomic, weak) UIView *orderView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickNameLbl;
@property (nonatomic, strong) MjtShopReadModel *shopModel;
@property (nonatomic, strong) MjtButton *waitPayBtn;//代付款
@property (nonatomic, strong) MjtButton *waitSendBtn;//代发货
@property (nonatomic, strong) MjtButton *waitReceiveBtn;//代收货
@property (nonatomic, strong) MjtButton *comment_countBtn;//代评价
@property (nonatomic, strong) MjtButton *return_countBtn;//售后
@end

@implementation MineViewController

#pragma mark -- 系统回调方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self _requestData];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupNavigation];
    [self _setupSubviews];
    [self _setupData];
   
}
- (void)_requestData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"isDecrypt"] = @"NO";
    [NetBaseTool postWithUrl:MJT_SHOP_UNREADCOUNT_PATH params:param decryptResponse:NO showHud:NO success:^(id responseDict) {
        if ([responseDict[@"status"] intValue] == 200) {
            self.shopModel = [MjtShopReadModel mj_objectWithKeyValues:responseDict[@"data"]];
            self.waitPayBtn.redDotNumber = self.shopModel.waitPay;
            self.waitSendBtn.redDotNumber = self.shopModel.waitSend;
            self.waitReceiveBtn.redDotNumber = self.shopModel.waitReceive;
            self.comment_countBtn.redDotNumber = self.shopModel.comment_count;
            self.return_countBtn.redDotNumber = self.shopModel.return_count;
            
        }

       } failure:^(NSError *error) {
       }];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
}

- (void)_setupNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"me_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(_settingClick)];
}
- (void)_setupSubviews{
    [self _setupHeaderView];
    [self _setupTableView];
}

- (void)_setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView = self.headerView;
    CGRect rect=  CGRectOffset(self.tableView.bounds, 0, -self.tableView.bounds.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = MJTGlobalMainColor;
    [self.tableView insertSubview:bgView atIndex:0];
}
- (void)_setupHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)];    
    [self _setupUserView];
    [self _setupOrderView];
}
- (void)_setupUserView{
    UIView *userView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    userView.backgroundColor = MJTGlobalMainColor;
    [self.headerView addSubview:userView];
    self.userView = userView;
    MjtUserInfo *userInfo = [MjtUserInfo sharedUser];
    
    //头像
    UIImageView *avatar = [[UIImageView alloc] init];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"me_avatar"]];
    [userView addSubview:avatar];
    self.avatar = avatar;
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(0);
        make.left.mas_equalTo(18);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    avatar.layer.cornerRadius = 8;
    avatar.layer.masksToBounds = YES;
    
    //昵称
    UILabel *userLbl = [[UILabel alloc] init];
    userLbl.font = [UIFont boldSystemFontOfSize:17];
    userLbl.textColor = MJTColorFromHexString(@"#333333");
    userLbl.text = ([userInfo.user_name isEqualToString:@""] || userInfo.user_name == nil) ? @"未设置" : userInfo.user_name;
    [userView addSubview:userLbl];
    [userLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatar.mas_top).offset(5);
        make.left.mas_equalTo(avatar.mas_right).offset(12);
    }];
    self.nickNameLbl = userLbl;
    
    //手机号
    UILabel *phoneLbl = [[UILabel alloc] init];
    phoneLbl.font = [UIFont systemFontOfSize:13];
    phoneLbl.textColor = MJTColorFromHexString(@"#333333");
    phoneLbl.text = [MjtUserInfo sharedUser].mobile;
   [userView addSubview:phoneLbl];
   [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(avatar.mas_bottom).offset(-5);
       make.left.mas_equalTo(userLbl.mas_left);
   }];
    
    //箭头
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.image = [[UIImage imageNamed:@"icon-arrow1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];  // 设置根据TintColor渲染图片
    [arrowImg setTintColor:[UIColor blackColor]];
    [userView addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(userView.mas_right).with.offset(-25);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(avatar.mas_centerY);
    }];
    
    [userView addGestureRecognizer:({
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo_editClick)];
        tapGes;
    })];
}

- (void)_setupData{
    WeakSelf;
    MjtSettingItemModel *item1 = [[MjtSettingItemModel alloc] init];
    item1.funcName = @"服务订单";
    item1.img = [UIImage imageNamed:@"me_serviceOrder"];
    item1.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    item1.executeCode = ^{
        MjtServiceListVC *listVC = [[MjtServiceListVC alloc] init];
        [weakSelf.navigationController pushViewController:listVC animated:YES];
    };
   
    MjtSettingItemModel *item2 = [[MjtSettingItemModel alloc] init];
    item2.funcName = @"我的客服";
    item2.executeCode = ^{
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://4000101234"]]];//这个webView千万不要添加到界面上来，不然会挡住其他界面
    };
    item2.detailImage = [UIImage imageNamed:@"me_phone"];
    item2.img = [UIImage imageNamed:@"me_kefu"];
    item2.accessoryType = MJTSettingAccessoryTypeNone;
   
    MjtSettingItemModel *item3 = [[MjtSettingItemModel alloc] init];
    item3.funcName = @"地址管理";
    item3.img = [UIImage imageNamed:@"me_address"];
    item3.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^{
        MjtAddressListVC *addressVC = [[MjtAddressListVC alloc] init];
        [weakSelf.navigationController pushViewController:addressVC animated:YES];
    };
    
    MjtSettingItemModel *item4 = [[MjtSettingItemModel alloc] init];
    item4.funcName = @"我的家";
    item4.img = [UIImage imageNamed:@"me_home"];
    item4.accessoryType = MJTSettingAccessoryTypeDisclosureIndicator;
   
   MjtSettingSectionModel *sectionItem = [[MjtSettingSectionModel alloc] init];
   sectionItem.itemArray = @[item1,item2,item3,item4];
   self.sectionArray = @[sectionItem];
}
- (void)_setupOrderView{
    
    //姓名
   UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 20)];
    titleLbl.font = [UIFont boldSystemFontOfSize:14];
    titleLbl.textColor = MJTColorFromHexString(@"#2A2000");
   titleLbl.text = @"我的订单";
   [self.headerView addSubview:titleLbl];
    
    //查看全部订单
    MjtBaseButton *orderButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [orderButton setTitle:@"查看全部订单" forState:0];
    [orderButton setTitleColor:MJTColorFromHexString(@"#FFCE00") forState:0];
    orderButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:2.f];
    [orderButton addTarget:self action:@selector(_orderButton_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:orderButton];
    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLbl.mas_centerY);
        make.right.mas_equalTo(self.headerView.mas_right).with.offset(-20);
    }];
    
       CGFloat marginY = MJTGlobalViewTopInset;
       CGFloat startY = CGRectGetMaxY(titleLbl.frame) + 30;
       MjtButton *lastBtn;
       for (int i = 0; i < self.dataArray.count; i++)
       {
           
           NSDictionary *dic = self.dataArray[i];
           NSString *title = dic[@"title"];
           MjtButton *btn = [MjtButton buttonWithType:UIButtonTypeCustom];
           [btn setTitle:title forState:UIControlStateNormal];
           [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
           btn.titleLabel.font = [UIFont systemFontOfSize:12];
           [btn addTarget:self action:@selector(_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
           [btn setTitleColor:MJTColorFromHexString(@"#727272") forState:UIControlStateNormal];
           int row = i / kColCount;
           int col = i % kColCount;
           CGFloat x = kStartX + col * (kMarginX + kAppViewW);
           CGFloat y =  startY + marginY + row * (marginY + kAppViewH);
           btn.imageWH = 30;
           btn.margin = 12.f;
           btn.frame = CGRectMake(x, y, kAppViewW, kAppViewH);
           
           btn.redDotColor = [UIColor redColor];
           btn.redDotNumber = 0;
           btn.redDotRadius = 5.0;
           btn.redDotOffset = CGPointMake(-10, 2);
           btn.redDotBorderColor = [UIColor orangeColor];
           btn.redDotBorderWidth = 1.0;
           
           if ([title isEqualToString:@"待付款"]) {
               self.waitPayBtn = btn;
           }else  if ([title isEqualToString:@"待发货"]) {
               self.waitSendBtn = btn;
           }else  if ([title isEqualToString:@"待收货"]) {
               self.waitReceiveBtn = btn;
           }else  if ([title isEqualToString:@"评价"]) {
               self.comment_countBtn = btn;
           }else  if ([title isEqualToString:@"售后"]) {
               self.return_countBtn = btn;
           }
           [btn  ShowBadgeView];
//           [btn setBackgroundColor:MJTRandomColor];
           [self.headerView addSubview:btn];
           if (i == self.dataArray.count - 1) {
               lastBtn = btn;
           }
       }
    CGFloat  maxY = CGRectGetMaxY(lastBtn.frame) + 20;
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(self.view.mas_left);
//        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(maxY);
//    }];
}

#pragma mark -- 点击事件
- (void)_settingClick{
    MjtSettingVC *settingVC = [[MjtSettingVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)_buttonClick:(MjtButton *)button{
    NSString *title = button.titleLabel.text;
    MjtWebView *webView = [[MjtWebView alloc] init];

    if ([title isEqualToString:@"待付款"]) {
    webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_WAITPAY_PATH)];
    } else if ([title isEqualToString:@"待发货"]) {
        webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_WAITDELIVER_PATH)];
    }else if ([title isEqualToString:@"待收货"]) {
        webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_WAITRECEIVE_PATH)];
    }else if ([title isEqualToString:@"评价"]) {
        webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_WAITCOMMENT_PATH)];
    }else if ([title isEqualToString:@"售后"]) {
        webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_AFTERSELL_PATH)];
    }
//     if (![title isEqualToString:@"待发货"]) {
         [self.navigationController pushViewController:webView animated:YES];
//    }
}
- (void)_homeBtnClick:(MjtBaseButton *)button{
    MJTLog(button.titleLabel.text );
    if([button.titleLabel.text isEqualToString:@"我的方案"]){
        MjtWebView *webView = [[MjtWebView alloc] init];
        webView.title = @"我的方案";
        webView.urlString = KURL(MJT_SCHEMA_PATH);
        [self.navigationController pushViewController:webView animated:YES];
    }
}
- (void)_orderButton_Click{
    MjtWebView *webView = [[MjtWebView alloc] init];
    webView.urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_ORDERLIST_PATH)];
    [self.navigationController pushViewController:webView animated:YES];
}
///个人信息 --修改
- (void)userInfo_editClick{
    MjtUserInfoEditVC *userInfoVC = [[MjtUserInfoEditVC alloc] init];
    WeakSelf;
    userInfoVC.avatarAction = ^(NSString * _Nonnull avatarPath) {
        [weakSelf.avatar sd_setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:@"me_avatar"]];
    };
    userInfoVC.nickNameAction = ^(NSString * _Nonnull nickName) {
        weakSelf.nickNameLbl.text = nickName;
    };
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MjtSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    MjtSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MjtSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    MjtSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MjtSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = itemModel;
    if(indexPath.row == sectionModel.itemArray.count - 1){
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MjtSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MjtSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MjtSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
    
    if(indexPath.row == sectionModel.itemArray.count - 1){
        itemModel.isSelected = !itemModel.isSelected;
        MjtSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (itemModel.isSelected) {
            self.tableView.tableFooterView = self.footerView;
            [UIView animateWithDuration:0.25 animations:^{
                cell.indicator.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
            }];

        }else{
            self.tableView.tableFooterView = [UIView new];
            [UIView animateWithDuration:0.25 animations:^{
               cell.indicator.transform = CGAffineTransformIdentity;
           }];
        }
    }
}
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MjtSettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;

    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark -- 数据懒加载
-(NSMutableArray *)homeArray{
    if (!_homeArray) {
        _homeArray = [NSMutableArray array];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"me_home.json" ofType:nil];
          NSData *data =  [NSData dataWithContentsOfFile:fileName];
          _homeArray =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return _homeArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"me_order.json" ofType:nil];
        NSData *data =  [NSData dataWithContentsOfFile:fileName];
        _dataArray =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return _dataArray;
}
-(UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
        CGFloat marginY = 8;
        CGFloat startY = 0;
        int colCount = 3;
        int appViewW = 90;
        int marginX =  (ScreenWidth - colCount * 90-kStartX*2) / (colCount - 1);
        for (int i = 0; i < self.homeArray.count; i++)
        {
            NSDictionary *dic = self.homeArray[i];
            MjtButton *btn = [MjtButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(_homeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:MJTColorFromHexString(@"#727272") forState:UIControlStateNormal];
            int row = i / colCount;
            int col = i % colCount;
            CGFloat x = kStartX + col * (marginX + appViewW);
            CGFloat y =  startY + marginY + row * (marginY + appViewW);
            btn.imageWH = 22;
            btn.margin = 12.f;
            btn.frame = CGRectMake(x, y, appViewW, 45);
            [_footerView addSubview:btn];
        }
//        _footerView.backgroundColor = MJTRandomColor;
        
    }
    return _footerView;
}
@end
