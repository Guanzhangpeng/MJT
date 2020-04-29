//
//  MjtFogetPassword.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/27.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtFogetPassword.h"
#import "RegularHelp.h"
#import "GSProxy.h"
@interface MjtFogetPassword (){
    NSTimer *_timer;
    int _leftTime;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *codeTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end

@implementation MjtFogetPassword
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.title = @"找回密码";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
- (void)_setupSubviews{
    self.sureButton.backgroundColor = MJTGlobalMainColor;
    self.codeButton.layer.borderWidth = 0.5f;
    self.codeButton.layer.borderColor = MJTGlobalMainColor.CGColor;
    self.codeButton.layer.cornerRadius = 8.f;
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

#pragma mark -- 点击事件
- (IBAction)sureButton_Click:(id)sender {
    if (![RegularHelp validateUserPhone:self.phoneTxt.text] ) {
          [MBProgressHUD wj_showPlainText:@"请输入合法的手机号" view:self.view];
          return;
      }
      if ([self.codeTxt.text isEqualToString:@""] ) {
          [MBProgressHUD wj_showPlainText:@"请输入验证码" view:self.view];
          return;
      }
      if ([self.passwordTxt.text isEqualToString:@""] ) {
          [MBProgressHUD wj_showPlainText:@"请输入密码" view:self.view];
          return;
      }

      NSMutableDictionary *param = [NSMutableDictionary dictionary];
      param[@"mobile"] = self.phoneTxt.text;
      param[@"code"] = self.codeTxt.text;
      param[@"password"] = self.passwordTxt.text;
      
      WeakSelf;
     [NetBaseTool postWithUrl:MJT_PORGETPWD_PATH params:param decryptResponse:YES showHud:YES success:^(id responseDict) {
         if ([responseDict[@"status"] intValue] == 200) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             });
         }
     } failure:^(NSError *error) {

     }];
}
- (IBAction)codeButton_Click:(id)sender {
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
