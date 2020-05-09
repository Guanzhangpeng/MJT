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
#import "RegularHelp.h"
#import "MjtFogetPassword.h"
#import "GSProxy.h"
@interface MjtLoginVC ()<UITextViewDelegate>{
    NSTimer *_timer;
    int _leftTime;
}
@property (nonatomic, weak) MjtTextField *phoneTxt;
@property (nonatomic, weak) MjtTextField *codeTxt;
@property (nonatomic, weak) MjtTextField *pwdTxt;
@property (nonatomic, weak) MjtBaseButton *codeButton;
@property (nonatomic, weak) MjtBaseButton *fogetBtn;
@property (nonatomic, weak) MjtBaseButton *loginType;

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
        make.height.mas_equalTo(380);
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
    
    MjtBaseButton *loginType = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [loginType setTitle:@"用验证码登录" forState:UIControlStateNormal];
    [loginType setTitle:@"用账号密码登录" forState:UIControlStateSelected];
    [loginType setTitleColor:MJTGlobalMainColor forState:UIControlStateNormal];
    loginType.titleLabel.font = [UIFont systemFontOfSize:12];
    [loginType addTarget:self action:@selector(_typeAction:) forControlEvents:UIControlEventTouchUpInside];
    loginType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [contentView addSubview:loginType];
    [loginType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView.mas_right).with.offset(-30);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(loginLbl.mas_centerY);
        make.width.mas_equalTo(200);
    }];
    self.loginType = loginType;
    
    MjtTextField *unameTxt = [[MjtTextField alloc] init];
    unameTxt.placeholder = @"请输入手机号";
    unameTxt.clearButtonMode =  UITextFieldViewModeWhileEditing;
    unameTxt.keyboardType = UIKeyboardTypePhonePad;
    [contentView addSubview:unameTxt];
    [unameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginLbl.mas_bottom).with.offset(40);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.phoneTxt = unameTxt;
    
    MjtTextField *passWordTxt = [[MjtTextField alloc] init];
    passWordTxt.placeholder = @"请输入密码";
    passWordTxt.secureTextEntry = YES;
    [contentView addSubview:passWordTxt];
    [passWordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unameTxt.mas_bottom).with.offset(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.pwdTxt = passWordTxt;
    
    MjtBaseButton *codeButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:MJTGlobalMainColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [codeButton addTarget:self action:@selector(_codeAction:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [contentView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(passWordTxt.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(90);
        make.centerY.mas_equalTo(self.pwdTxt.mas_centerY);
    }];
    codeButton.hidden = YES;
    self.codeButton = codeButton;
    
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
    self.fogetBtn = fogetBtn;
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
- (void)_loginAction{
    if (![RegularHelp validateUserPhone:self.phoneTxt.text] ) {
        [MBProgressHUD wj_showPlainText:@"请输入合法的手机号" view:self.view];
        return;
    }
    if (self.loginType.selected) {
        if ([self.pwdTxt.text isEqualToString:@""] ) {
            [MBProgressHUD wj_showPlainText:@"请输入验证码" view:self.view];
            return;
        }
    }else{
        if ([self.pwdTxt.text isEqualToString:@""] ) {
            [MBProgressHUD wj_showPlainText:@"请输入密码" view:self.view];
            return;
        }
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.phoneTxt.text;
    if (self.loginType.selected) {
        param[@"mobilecode"] = self.pwdTxt.text;
        //    1：验证码登录，2：账号密码登录，3：获取验证码
        param[@"type"] = @"1";
    }else{
        param[@"user_pwd"] = self.pwdTxt.text;
        param[@"type"] = @"2";
    }
    [NetBaseTool postWithUrl:MJT_LOGIN_PATH params:param decryptResponse:YES showHud:YES success:^(id responseDict) {
        MjtUserInfo *userInfo = [MjtUserInfo userWithDict:responseDict[@"data"]];
        [MjtUserInfo saveDataToKeyChian];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
    
}
- (void)_registerAction{
    [self.navigationController pushViewController:[MjtRegisterVC new] animated:YES];
}

///获取验证码
- (void)_codeAction:(MjtBaseButton *)button{
        if (![RegularHelp validateUserPhone:self.phoneTxt.text] ) {
            [MBProgressHUD wj_showPlainText:@"请输入合法的手机号" view:self.view];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"mobile"] = self.phoneTxt.text;

    //    1：验证码登录，2：账号密码登录，3：获取验证码
       param[@"type"] = @"3";
       
        WeakSelf;
       [NetBaseTool postWithUrl:MJT_LOGIN_PATH params:param decryptResponse:YES showHud:YES success:^(id responseDict) {
           weakSelf.codeButton.enabled = NO;
           weakSelf.codeButton.selected = YES;
           self->_leftTime = 120;
           self->_timer = [NSTimer timerWithTimeInterval:1.0f target:[GSProxy proxyWithTarget:self] selector:@selector(_leftTime) userInfo:nil repeats:YES];
           [[NSRunLoop mainRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
           
       } failure:^(NSError *error) {
           [self updatePhoneCodeButton];
       }];
}

///验证码登录
- (void)_typeAction:(MjtBaseButton *)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        self.pwdTxt.placeholder = @"输入验证码";
        self.codeButton.hidden = NO;
        self.fogetBtn.hidden = YES;
    }else{
        self.pwdTxt.placeholder = @"请输入密码";
        self.codeButton.hidden = YES;
         self.fogetBtn.hidden = NO;
    }
}

///忘记密码
- (void)_fogetAction{
    [self.navigationController pushViewController:[MjtFogetPassword new] animated:YES];
}


-(void)_leftTime
{
    if (_leftTime > 0) {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ds后重发",_leftTime] forState:UIControlStateNormal];
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
    self.codeButton.enabled = YES;
    self.codeButton.selected = NO;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}
#pragma mark -- UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if([[URL scheme] isEqualToString:@"Lience"]){
        MjtWebView *webView = [[MjtWebView alloc] init];
        webView.urlString = @"https://www.baidu.com";
        [self.navigationController pushViewController:webView animated:YES];
        return NO;
    }
    return YES;
}
@end
