//
//  MjtLoginVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/10.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtLoginVC.h"
#import "UIImage+Extension.h"
#import "Masonry.h"
#import "MjtBaseButton.h"
#import "MjtRegisterVC.h"
#import "MjtTextField.h"
#import "MjtWebView.h"
@interface MjtLoginVC ()<UITextViewDelegate>

@end

@implementation MjtLoginVC

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(_registerAction)];
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
    
    //登录
    UILabel *loginLbl = [[UILabel alloc] init];
    loginLbl.font = [UIFont boldSystemFontOfSize:17];
    loginLbl.textColor = MJTColorFromHexString(@"#333333");
    loginLbl.text = @"登录";
    [contentView addSubview:loginLbl];
    [loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(60);
    }];

    [yelloView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginLbl.mas_right).with.offset(-12);
        make.top.mas_equalTo(loginLbl.mas_top).with.offset(3);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    MjtBaseButton *codeButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"用验证码登录" forState:UIControlStateNormal];
    [codeButton setTitleColor:MJTGlobalMainColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [codeButton addTarget:self action:@selector(_codeLoginAction) forControlEvents:UIControlEventTouchUpInside];
    codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [contentView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView.mas_right).with.offset(-30);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(loginLbl.mas_centerY);
        make.width.mas_equalTo(200);
    }];
    
    MjtTextField *unameTxt = [[MjtTextField alloc] init];
    unameTxt.placeholder = @"请输入手机号";
    [contentView addSubview:unameTxt];
    [unameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginLbl.mas_bottom).with.offset(40);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    
    
    MjtTextField *passWordTxt = [[MjtTextField alloc] init];
    passWordTxt.placeholder = @"请输入密码";
    [contentView addSubview:passWordTxt];
    [passWordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unameTxt.mas_bottom).with.offset(20);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    
    //忘记密码
    MjtBaseButton *fogetBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [fogetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [fogetBtn setTitleColor:MJTColorFromHexString(@"#999999") forState:UIControlStateNormal];
    fogetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [fogetBtn addTarget:self action:@selector(_fogetAction) forControlEvents:UIControlEventTouchUpInside];
    fogetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [contentView addSubview:fogetBtn];
    [fogetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(passWordTxt.mas_right).with.offset(-12);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(passWordTxt.mas_bottom).with.offset(8);
    }];
    
    //登录按钮
    MjtBaseButton *loginBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
       [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
       [loginBtn setTitleColor:MJTColorFromHexString(@"#000000") forState:UIControlStateNormal];
       loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = MJTGlobalMainColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.masksToBounds = YES;
       [loginBtn addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
       [contentView addSubview:loginBtn];
       [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(passWordTxt.mas_left).with.offset(8);
           make.right.mas_equalTo(passWordTxt.mas_right).with.offset(-8);
           make.height.mas_equalTo(40);
           make.top.mas_equalTo(fogetBtn.mas_bottom).with.offset(40);
       }];
    
    //协议
    NSMutableAttributedString *attributtedString = [[NSMutableAttributedString alloc] initWithString:@"登录即表示同意美嘉兔用户协议条款"];
    [attributtedString addAttribute:NSLinkAttributeName value:@"Lience://" range:[[attributtedString string] rangeOfString:@"美嘉兔用户协议条款"]];
    [attributtedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributtedString.length)];

    UITextView *lienceTxt = [[UITextView alloc] init];
    lienceTxt.attributedText = attributtedString;
    lienceTxt.linkTextAttributes = @{NSForegroundColorAttributeName:MJTColorFromHexString(@"#3E3E3E"),
       
    };
    lienceTxt.delegate = self;
    lienceTxt.scrollEnabled = NO;
    lienceTxt.editable = NO;
//    lienceTxt.selectable = NO;
    lienceTxt.textColor = MJTColorFromHexString(@"#919191");
    [contentView addSubview:lienceTxt];
    [lienceTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(210);
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

///验证码登录
- (void)_codeLoginAction{
    
}

///忘记密码
- (void)_fogetAction{
    
}

///登录
- (void)_loginAction{
    
}

#pragma mark -- UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if([[URL scheme] isEqualToString:@"Lience"]){
        MjtWebView *webView = [[MjtWebView alloc] init];
        webView.url = @"https://www.baidu.com";
        [self.navigationController pushViewController:webView animated:YES];
        return NO;
    }
    return YES;
}
@end
