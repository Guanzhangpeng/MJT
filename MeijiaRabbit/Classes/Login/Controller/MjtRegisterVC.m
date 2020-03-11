//
//  MjtRegisterVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/11.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtRegisterVC.h"
#import "UIImage+Extension.h"
#import "Masonry.h"
#import "MjtBaseButton.h"
#import "MjtTextField.h"
#import "GSProxy.h"
@interface MjtRegisterVC (){
    NSTimer *_timer;
    int _leftTime;
}
/// 获取验证码
@property (nonatomic, weak) MjtBaseButton *codeBtn;
@end

@implementation MjtRegisterVC

#pragma mark -- 系统回调方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#FFCE00")] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupNavigation];
    [self _setupSubviews];
    [self _makeSubviewConstraints];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)_setupNavigation{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(_closeAction)];
}
- (void)_setupSubviews{
    //背景图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8.f;
    contentView.layer.masksToBounds = YES;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth *5/6);
        make.height.mas_equalTo(ScreenHeight*2/3);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    //装饰
    UIView *yelloView = [[UIView alloc] init];
    yelloView.backgroundColor = MJTColorFromHexString(@"#FFCE00");
    yelloView.layer.cornerRadius = 9;
    yelloView.layer.masksToBounds = YES;
    [contentView addSubview: yelloView];
    
    UILabel *registerLbl = [[UILabel alloc] init];
    registerLbl.font = [UIFont boldSystemFontOfSize:17];
    registerLbl.textColor = MJTColorFromHexString(@"#333333");
    registerLbl.text = @"注册";
    [contentView addSubview:registerLbl];
    [registerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(20);
    }];

    [yelloView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(registerLbl.mas_right).with.offset(-12);
        make.top.mas_equalTo(registerLbl.mas_top).with.offset(3);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
   
    
    MjtTextField *unameTxt = [[MjtTextField alloc] init];
    unameTxt.placeholder = @"请输入手机号";
    [contentView addSubview:unameTxt];
    [unameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerLbl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];

    
    MjtTextField *codeTxt = [[MjtTextField alloc] init];
    codeTxt.placeholder = @"请输入验证码";
    [contentView addSubview:codeTxt];
    
    [codeTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unameTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    MjtBaseButton *codeButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
       [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
       [codeButton setTitleColor:MJTGlobalMainColor forState:UIControlStateNormal];
       codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
       [codeButton addTarget:self action:@selector(_codeAction) forControlEvents:UIControlEventTouchUpInside];
       codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
       [contentView addSubview:codeButton];
       self.codeBtn = codeButton;
//    codeButton.backgroundColor = MJTRandomColor;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView.mas_right).with.offset(-25);
        make.height.mas_equalTo(36);
        make.centerY.mas_equalTo(codeTxt.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    
    MjtTextField *passWordTxt = [[MjtTextField alloc] init];
    passWordTxt.placeholder = @"请输入密码";
    [contentView addSubview:passWordTxt];
    [passWordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    
    MjtTextField *passWord2 = [[MjtTextField alloc] init];
    passWord2.placeholder = @"请确认您的密码";
    [contentView addSubview:passWord2];
    [passWord2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passWordTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
        
  

    MjtBaseButton *loginBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
       [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
       [loginBtn setTitleColor:MJTColorFromHexString(@"#FFFFFF") forState:UIControlStateNormal];
       loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = MJTGlobalMainColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.masksToBounds = YES;
       [loginBtn addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
       [contentView addSubview:loginBtn];
       [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(passWord2.mas_left).with.offset(8);
           make.right.mas_equalTo(passWord2.mas_right).with.offset(-8);
           make.height.mas_equalTo(40);
           make.top.mas_equalTo(passWord2.mas_bottom).with.offset(40);
       }];
    
    //协议
    UILabel *lienceLbl = [[UILabel alloc] init];
    lienceLbl.font = [UIFont boldSystemFontOfSize:12];
    lienceLbl.textColor = MJTColorFromHexString(@"#999999");
    lienceLbl.text = @"注册即表示同意美嘉兔用户协议条款";
    [contentView addSubview:lienceLbl];
    [lienceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.bottom.mas_equalTo(-20);
    }];
    
}
- (void)_makeSubviewConstraints{
    
}

#pragma  mark -- 点击事件
- (void)_closeAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)_registerAction{
    [self.navigationController pushViewController:[MjtRegisterVC new] animated:YES];
}

///获取验证码
- (void)_codeAction{
    self.codeBtn.enabled = NO;
    self.codeBtn.selected = YES;
    _leftTime = 120;
   _timer = [NSTimer timerWithTimeInterval:1.0f target:[GSProxy proxyWithTarget:self] selector:@selector(leftTime) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

///忘记密码
- (void)_fogetAction{
    
}

///登录
- (void)_loginAction{
    
}

-(void)leftTime
{
    if (_leftTime > 0) {
        self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重发",_leftTime] forState:UIControlStateNormal];
        _leftTime--;
        if (_leftTime==0) {
            [self updatePhoneCodeButton];
        }
        return;
    }
}

-(void)updatePhoneCodeButton
{
    [_timer invalidate];
    _timer = nil;
    self.codeBtn.enabled = YES;
    self.codeBtn.selected = NO;
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

@end
