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
#import "RegularHelp.h"
#import "MjtWebView.h"
#import "JPUSHService.h"
@interface MjtRegisterVC ()<UITextViewDelegate>{
    NSTimer *_timer;
    int _leftTime;
}
/// 获取验证码
@property (nonatomic, weak) MjtBaseButton *codeBtn;
@property (nonatomic, weak) MjtTextField *phoneTxt;
@property (nonatomic, weak) MjtTextField *codeTxt;
@property (nonatomic, weak) MjtTextField *pwdTxt;
@property (nonatomic, weak) MjtTextField *pwdAgainTxt;
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
    unameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    unameTxt.keyboardType = UIKeyboardTypePhonePad;
    [contentView addSubview:unameTxt];
    [unameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerLbl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.phoneTxt = unameTxt;
    
    
    MjtTextField *codeTxt = [[MjtTextField alloc] init];
    codeTxt.placeholder = @"请输入验证码";
    [contentView addSubview:codeTxt];
    
    [codeTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unameTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.codeTxt = codeTxt;
    
    MjtBaseButton *codeButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
       [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
       [codeButton setTitleColor:MJTGlobalMainColor forState:UIControlStateNormal];
       codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
       [codeButton addTarget:self action:@selector(_codeAction) forControlEvents:UIControlEventTouchUpInside];
       codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
       [contentView addSubview:codeButton];
       self.codeBtn = codeButton;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView.mas_right).with.offset(-25);
        make.height.mas_equalTo(36);
        make.centerY.mas_equalTo(codeTxt.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    
    MjtTextField *passWordTxt = [[MjtTextField alloc] init];
    passWordTxt.placeholder = @"请输入密码";
    passWordTxt.secureTextEntry = YES;
    [contentView addSubview:passWordTxt];
    [passWordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.pwdTxt = passWordTxt;
    
    MjtTextField *passWord2 = [[MjtTextField alloc] init];
    passWord2.placeholder = @"请确认您的密码";
    passWord2.secureTextEntry = YES;
    [contentView addSubview:passWord2];
    [passWord2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passWordTxt.mas_bottom).with.offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    self.pwdAgainTxt = passWord2;
  

    MjtBaseButton *loginBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
       [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
       [loginBtn setTitleColor:MJTColorFromHexString(@"#FFFFFF") forState:UIControlStateNormal];
       loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = MJTGlobalMainColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.masksToBounds = YES;
       [loginBtn addTarget:self action:@selector(_registerAction) forControlEvents:UIControlEventTouchUpInside];
       [contentView addSubview:loginBtn];
    
       [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(passWord2.mas_left).with.offset(8);
           make.right.mas_equalTo(passWord2.mas_right).with.offset(-8);
           make.height.mas_equalTo(40);
           make.top.mas_equalTo(passWord2.mas_bottom).with.offset(40);
       }];
    
    
//    协议
        NSMutableAttributedString *attributtedString = [[NSMutableAttributedString alloc] initWithString:@"登录即表示同意美嘉兔用户协议条款"];
        [attributtedString addAttribute:NSLinkAttributeName value:@"Lience://" range:[[attributtedString string] rangeOfString:@"美嘉兔用户协议条款"]];
    [attributtedString addAttribute:NSLinkAttributeName value:@"baidu://" range:[[attributtedString string] rangeOfString:@"百度"]];
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
            make.height.mas_equalTo(22);
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
    if (![RegularHelp validateUserPhone:self.phoneTxt.text] ) {
        [MBProgressHUD wj_showPlainText:@"请输入合法的手机号" view:self.view];
        return;
    }
    if ([self.codeTxt.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请输入验证码" view:self.view];
        return;
    }
    if ([self.pwdTxt.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请输入密码" view:self.view];
        return;
    }
    if ([self.pwdAgainTxt.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请再次输入密码" view:self.view];
        return;
    }
    if (![self.pwdAgainTxt.text isEqualToString:self.pwdTxt.text] ) {
        [MBProgressHUD wj_showPlainText:@"密码不一致" view:self.view];
        return;
    }
    NSString* jPushRegistID = [JPUSHService registrationID];
    if (jPushRegistID == nil) jPushRegistID = @"";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.phoneTxt.text;
    param[@"vcode"] = self.codeTxt.text;
    param[@"input_password"] = self.pwdTxt.text;
    param[@"confirm_password"] = self.pwdAgainTxt.text;
    param[@"aurora_id"] = jPushRegistID;//极光ID
    WeakSelf;
   [NetBaseTool postWithUrl:MJT_REGISTER_PATH params:param decryptResponse:YES showHud:NO  success:^(id responseDict) {
       
       if ([responseDict[@"status"] intValue] == 200) {
           [weakSelf registerSHOP:self.phoneTxt.text];
           
           MjtUserInfo *userInfo = [MjtUserInfo userWithDict:responseDict[@"data"]];
           [MjtUserInfo saveDataToKeyChian];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
               [weakSelf.navigationController popToRootViewControllerAnimated:YES];
           });
       }
   } failure:^(NSError *error) {

   }];
}
- (void)registerSHOP:(NSString *)phone{
    WeakSelf;
   NSString *url =  [NSString stringWithFormat:@"%@/mobile/api/app_reg?mobile=%@",MJT_HTMLSHOPROOT_PATH,phone];
    [NetBaseTool getWithUrl:url params:nil decryptResponse:NO success:^(id responeseObject) {
        if ([responeseObject[@"status"] intValue] == 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
    }];
}
///获取验证码
- (void)_codeAction{
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
       weakSelf.codeBtn.enabled = NO;
       weakSelf.codeBtn.selected = YES;
       self->_leftTime = 120;
       self->_timer = [NSTimer timerWithTimeInterval:1.0f target:[GSProxy proxyWithTarget:self] selector:@selector(_leftTime) userInfo:nil repeats:YES];
       [[NSRunLoop mainRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
       
   } failure:^(NSError *error) {
       [self updatePhoneCodeButton];
   }];
}


-(void)_leftTime
{
    if (_leftTime > 0) {
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
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}
#pragma mark -- UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if([[URL scheme] isEqualToString:@"Lience"]){
        MjtWebView *webView = [[MjtWebView alloc] init];
        webView.urlString = @"https://www.baidu.com";
        [self.navigationController pushViewController:webView animated:YES];
        return NO;
    }else     if([[URL scheme] isEqualToString:@"baidu"]){
        MJTLog(@"baidu");
        return NO;
    }
    return YES;
}
@end
