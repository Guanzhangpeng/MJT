//
//  MjtWebView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtWebView.h"
#import <WebKit/WebKit.h>
#import "UIImage+Extension.h"
// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
@implementation WeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface MjtWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation MjtWebView
- (void)dealloc{
    //移除注册的js方法
    
    //浏览器返回
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsCallAPPFinish"];
    
  
    
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.hideNav isEqualToString:@"YES"]) {
       [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if ([self.hideNav isEqualToString:@"YES"]) {
//          self.navigationController.navigationBarHidden = NO;
//          [self setStatusBarBackgroundColor:[UIColor clearColor]];
//      }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {

    if(@available(iOS 13.0, *)) {

        static UIView* statusBar =nil;

        if(!statusBar) {

  UIWindow*keyWindow = [UIApplication sharedApplication].windows[0];

            statusBar = [[UIView alloc]initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];

            [keyWindow addSubview:statusBar];

            [statusBar setBackgroundColor:color];

        }else{

          [statusBar setBackgroundColor:color];

        }

    }else{

        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];

        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

          [statusBar setBackgroundColor:color];

        }

    }

}
// GDP目标的问题 疫情病毒源头的问题  台湾问题
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
//    if ([self.hideNav isEqualToString:@"YES"]) {
//
//          [self setStatusBarBackgroundColor:[UIColor whiteColor]];
//      }
    

}

- (void)_setup{
   
}
- (void)_setupSubviews{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

//被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    NSDictionary * parameter = message.body;

    __weak typeof(self) weakSelf = self;
    //JS调用OC
    if([message.name isEqualToString:@"jsCallAPPFinish"]){
        if(weakSelf.webView.canGoBack){
            [weakSelf.webView goBack];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark -- WKNavigationDelegate
    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
}
    //提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
   // 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
    // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    NSString *htmlHeadString = @"github://";
    if([urlStr hasPrefix:htmlHeadString]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
            [[UIApplication sharedApplication] openURL:url];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
    
// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
    //需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}
    //进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}

#pragma mark ---- WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//     [OMGToast showWithText:message];
//}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#pragma mark - KVO
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
#pragma mark --- 懒加载
- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 2)];
        _progressView.tintColor = MJTGlobalMainColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
-(WKWebView *)webView
{
    if (!_webView) {
        
        //创建网页配置对象
       WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
       WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        
       //这个类主要用来做native与JavaScript的交互管理
       WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        
       //注册一个name为jsCallAPPFinish的js方法 设置处理接收JS方法的对象
       [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsCallAPPFinish"];
       
       config.userContentController = wkUController;

       
        if ([self.hideNav isEqualToString:@"YES"]) {
             _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight) configuration:config];
        }else{
             _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TOP_BAR_HEIGHT) configuration:config];
        }
      
         // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    return _webView;
}
#pragma mark -- 点击事件
- (void)_backClick{
    if (!self.webView.canGoBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
}
@end
