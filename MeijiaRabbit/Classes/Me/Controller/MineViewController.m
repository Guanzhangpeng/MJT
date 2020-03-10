//
//  MineViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MineViewController.h"
#import "Masonry.h"
#import "MjtButton.h"

#define kAppViewW 60
#define kAppViewH 60
#define kColCount 5
#define kMarginX (ScreenWidth - kColCount * kAppViewW-kStartX*2) / (kColCount - 1)
#define kStartY   0
#define kStartX   20

@interface MineViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIView *userView;
@property (nonatomic, weak) UIView *orderView;
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
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupNavigation];
    [self _setupSubviews];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
}

- (void)_setupNavigation{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"me_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(_settingClick)];
}
- (void)_setupSubviews{
    [self _setupUserView];
    [self _setupOrderView];
}

- (void)_setupUserView{
    UIView *userView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    userView.backgroundColor = MJTGlobalMainColor;
    [self.view addSubview:userView];
    self.userView = userView;
    
    //头像
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 60, 60)];
    avatar.image = [UIImage imageNamed:@"me_avatar"];
    avatar.layer.cornerRadius = 25;
    avatar.layer.masksToBounds = YES;
    [userView addSubview:avatar];
    
    //昵称
    UILabel *userLbl = [[UILabel alloc] init];
    userLbl.font = [UIFont systemFontOfSize:12];
    userLbl.textColor = MJTColorFromHexString(@"#333333");
    userLbl.text = @"美嘉兔";
    [userView addSubview:userLbl];
    [userLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(avatar.mas_centerY).offset(-10);
        make.left.mas_equalTo(avatar.mas_right).offset(8);
    }];
    
    //手机号
    UILabel *phoneLbl = [[UILabel alloc] init];
    phoneLbl.font = [UIFont systemFontOfSize:12];
    phoneLbl.textColor = MJTColorFromHexString(@"#333333");
   phoneLbl.text = @"1566668888";
   [userView addSubview:phoneLbl];
   [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(userLbl.mas_bottom).offset(8);
       make.left.mas_equalTo(userLbl.mas_left);
   }];
}
- (void)_setupOrderView{
    
    //我的订单
   UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 20)];
    titleLbl.font = [UIFont boldSystemFontOfSize:14];
    titleLbl.textColor = MJTColorFromHexString(@"#2A2000");
   titleLbl.text = @"我的订单";
   [self.view addSubview:titleLbl];
    
    //查看全部订单
    UILabel *orderLbl = [[UILabel alloc] init];
     orderLbl.font = [UIFont systemFontOfSize:12 weight:2.f];
     orderLbl.textColor = MJTColorFromHexString(@"#FFCE00");
    orderLbl.text = @"查看全部订单";
    [self.view addSubview:orderLbl];
    [orderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLbl.mas_centerY);
        make.right.mas_equalTo(self.view).with.offset(-20);
    }];
    
       CGFloat marginY = MJTGlobalViewTopInset;
       CGFloat startY = CGRectGetMaxY(titleLbl.frame) + 30;
       for (int i = 0; i < self.dataArray.count; i++)
       {
           NSDictionary *dic = self.dataArray[i];
           MjtButton *btn = [MjtButton buttonWithType:UIButtonTypeCustom];
           [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
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
           [self.view addSubview:btn];
       }
}

#pragma mark -- 点击事件
- (void)_settingClick{
    
}
- (void)_buttonClick:(MjtButton *)button{
    MJTLog(button.titleLabel.text);
}

#pragma mark -- 数据懒加载
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
@end
