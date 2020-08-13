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
#import <AlipaySDK/AlipaySDK.h>
#import "SPAlertController.h"
#import "GSProxy.h"
#import "MjtBaseButton.h"
#import "MjtLoginVC.h"
#import "NSString+YYAdd.h"
#import "YBImageBrowser.h"
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

@interface MjtWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    NSInteger count;
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MjtBaseButton *closeBtn;
@property (nonatomic, strong) NSString *trade_no;
@end

@implementation MjtWebView
- (void)dealloc{
    
    //浏览器返回
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsCallAPPFinish"];
     [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"serviceOrderPay"];
     [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"loginAction"];
    
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
    if ([self.hideNav isEqualToString:@"YES"]) {
          self.navigationController.navigationBarHidden = NO;
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
    [self.webView addObserver:self
                   forKeyPath:@"canGoBack"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ALPayResultCallBack:) name:NOTI_SERVICEORDER_PAYFINISH object:nil];
}

- (void)_setup{
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)_setupSubviews{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    leftView.userInteractionEnabled = YES;
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 22, 22)];
    backImg.contentMode = UIViewContentModeScaleAspectFit;
    backImg.image = [UIImage imageNamed:@"nav_back"];
    backImg.userInteractionEnabled = YES;
    [backImg addGestureRecognizer:({
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_backClick)];
        
        tapGes;
    })];
    [leftView addSubview:backImg];
    
    MjtBaseButton *closeBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"关闭" forState:0];
    [closeBtn setTitleColor:MJTColorFromHexString(@"333333") forState:0];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn addTarget:self action:@selector(_close_Click) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(35, 0, 50, 36);
    closeBtn.hidden = YES;
    [leftView addSubview:closeBtn];
    self.closeBtn = closeBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
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
    //导航栏返回
    if([message.name isEqualToString:@"jsCallAPPFinish"]){
        if(weakSelf.webView.canGoBack){
            [weakSelf.webView goBack];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } else if ([message.name isEqualToString:@"serviceOrderPay"]){
        //服务订单支付
        MJTLog(@"%@",parameter[@"params"]);
        NSString *appScheme =@"com.meijiatu.decoration";
        
        NSString *from = parameter[@"type"];
        [[NSUserDefaults standardUserDefaults] setObject:from forKey:@"PayFrom"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AlipaySDK defaultService] payOrder:parameter[@"params"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
               NSLog(@"reslut = %@",resultDic);
               [self ALPayResultHandle:resultDic];
           }];
    }else if([message.name isEqualToString:@"loginAction"]){
        NSString *urlString = parameter[@"params"];
        MjtLoginVC *loginVC = [[MjtLoginVC alloc] init];
        loginVC.popAction = ^{
           NSString *url = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,urlString];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        };
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 获取支付宝支付回调
- (void)ALPayResultCallBack:(NSNotification *) json{
    NSDictionary *resultDic = json.userInfo;
    [self  ALPayResultHandle:resultDic];
}

- (void)ALPayResultHandle:(NSDictionary *)resultDic{
    if ([resultDic[@"resultStatus"] intValue]==9000)
    {
        NSDictionary *result  =  [resultDic[@"result"] jsonValueDecoded];//[@"alipay_trade_app_pay_response"][@"trade_no"];
        NSDictionary *response = result[@"alipay_trade_app_pay_response"];
        self.trade_no = response[@"trade_no"];
        self.timer=[NSTimer timerWithTimeInterval:2.0f target:[GSProxy proxyWithTarget:self] selector:@selector(_checkPayResult) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付说明" message:@"用户支付失败或取消支付" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark -- 支付完成后调用后台回调
- (void)_checkPayResult{
    WeakSelf;
    count++;
    if (count>=5) {
        self.timer = nil;
        [self.timer invalidate];
    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        NSString *payFrom = [[NSUserDefaults standardUserDefaults] objectForKey:@"PayFrom"];
        NSString *path = MJT_CHECKPAY_PATH;
        bool isDecrypt = YES;
       if (![payFrom isEqualToString:@"userpay"]) {
           //从商城过来的
           path = MJT_CHECK_SHOPPAY_PATH;
           param[@"transaction"] = self.trade_no;
           param[@"mobile"] =  [MjtUserInfo sharedUser].mobile;
           param[@"isDecrypt"] = @"NO";
           isDecrypt= NO;
       }else{
         param[@"trade_no"] = self.trade_no;
         param[@"type"] = @"1"; //1:支付宝，2：微信
       }
        [NetBaseTool postWithUrl:path params:param decryptResponse:isDecrypt showHud:NO  success:^(id responseDict) {
            if ([responseDict[@"status"] intValue] == 200) {
                weakSelf.timer = nil;
                [weakSelf.timer invalidate];
                [MBProgressHUD wj_showPlainText:@"支付成功" view:self.view];
                if (![payFrom isEqualToString:@"userpay"]) {
                    //商城中支付成功
                     NSString *urlString = [NSString stringWithFormat:@"%@/mobile/api/do_login?mobile=%@&url=%@",MJT_HTMLSHOPROOT_PATH,[MjtUserInfo sharedUser].mobile,KShopUrl(MJT_ORDERLIST_PATH)];
                    [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
                    
                }else{
                    !weakSelf.payAction ?  :weakSelf.payAction();
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }else{
                if (self->count ==4) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付说明" message:@"用户支付失败或取消支付" preferredStyle:UIAlertControllerStyleAlert];
                                          [alertController addAction:([UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                              
                                          }])];
                  [weakSelf presentViewController:alertController animated:YES completion:nil];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"请求失败...............");
        }];
    }
}
#pragma mark -- WKNavigationDelegate
    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    MJTLog(@"开始加载页面了............");
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
     MJTLog(@"收到回调了............");

}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.imgsArray = [NSMutableArray array];
    
    if (![self.showPhotoBrowser isEqualToString:@"YES"]) {
        return;
    }
     MJTLog(@"页面加载完成............");
      //注入js 遍历img标签添加点击事件：跳转至自定义链接（包含图片src）
    //由于需求没有点击某个图片 侧滑查看所有图片（如有for循环结束时return objs.length;）
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\" + this.src;\
    };\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSMutableArray *urlArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
        //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
        NSLog(@"--%@",urlArray);
        [urlArray removeLastObject];
        
        [self.imgsArray addObjectsFromArray:urlArray];
        
    }];
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


    
            //捕获跳转链接
            NSURL *URL = navigationAction.request.URL;
            NSString *str = [NSString stringWithFormat:@"%@",URL];
            if ([str containsString:@"myweb:imageClick:"]) {
                //查看大图
                decisionHandler(WKNavigationActionPolicyCancel); // 必须实现 不加载
                int index = 0;
                NSString *currentUrl = [str componentsSeparatedByString:@"myweb:imageClick:"][1];
                NSMutableArray *datas = [NSMutableArray array];
                
                for (int i = 0; i < self.imgsArray.count; i++) {
                    
                    if ([self.imgsArray[i] isEqualToString:currentUrl]) {
                        index = i;
                    }
                    
                     // 网络图片
                    YBIBImageData *data = [YBIBImageData new];
                    data.imageURL = [NSURL URLWithString:self.imgsArray[i]];
        //            data.projectiveView = [self viewAtIndex:idx];
                    [datas addObject:data];

                }

                YBImageBrowser *browser = [YBImageBrowser new];
                browser.dataSourceArray = datas;
                browser.currentPage = index;
                // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                [browser show];
        
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);  // 必须实现 加载
    }
}
    
// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - KVO
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        NSString *title = [_webView.title componentsSeparatedByString:@"-"][0];
        self.navigationItem.title = title;
    }else if([keyPath isEqualToString:@"canGoBack"]
    && object == _webView){
        if(_webView.canGoBack){
            self.closeBtn.hidden = NO;
        }else{
            self.closeBtn.hidden = YES;
        }
    } else if([keyPath isEqualToString:@"loading"]
    && object == _webView){
    }
    else{
        [super observeValueForKeyPath:keyPath
        ofObject:object
          change:change
         context:context];
    }
}
#pragma mark --- 懒加载
- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        _progressView.tintColor = MJTGlobalMainColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
-(WKWebView *)webView{
    if (!_webView) {
        
        //创建网页配置对象
       WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
       WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        
       //这个类主要用来做native与JavaScript的交互管理
       WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        
       //注册一个name为jsCallAPPFinish的js方法 设置处理接收JS方法的对象
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsCallAPPFinish"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"serviceOrderPay"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"loginAction"];
       
       config.userContentController = wkUController;
      _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TOP_BAR_HEIGHT) configuration:config];
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
- (void)_close_Click{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
