/// MARK: - DDYAuthManager 2018/10/30
/// !!!: Author: 豆电雨
/// !!!: QQ/WX:  634778311
/// !!!: Github: https://github.com/RainOpen/
/// !!!: Blog:   https://juejin.im/user/57dddcd8128fe10064cadee9
/// MARK: - DDYCameraController.m

#import "DDYCameraController.h"
#import "DDYCameraManager.h"
#import "DDYCameraView.h"

#import "GSProxy.h"
#import "SGQRCodeScanView.h"
@interface DDYCameraController (){
    int count;
}
/// 相机管理器实例
@property (nonatomic, strong) DDYCameraManager *cameraManager;
/// 相机预览视图
@property (nonatomic, strong) DDYCameraView *cameraView;
/// 状态栏是否隐藏控制
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DDYCameraController
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.8 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.numberOfLines = 0;
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将面部自动对准框内, 即可得到您想要的装修风格";
    }
    return _promptLabel;
}
- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:self.view.bounds];
    }
    return _scanView;
}

///MARK: - 生命周期
- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}
- (void)_leftTime{
    if (count > 3) {
       if (self.recordVideoBlock) {
           self.recordVideoBlock(nil, self);
           return;
       }
    }
    count++;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:[GSProxy proxyWithTarget:self] selector:@selector(_leftTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    __weak __typeof__ (self)weakSelf = self;
    _cameraManager = [DDYCameraManager ddy_CameraWithContainerView:self.view];
    
    //切换摄像头
    [_cameraManager ddy_ToggleCamera];
    [_cameraManager setTakeFinishBlock:^(UIImage *image) {[weakSelf handleTakeFinish:image];}];
    [_cameraManager setRecordFinishBlock:^(NSURL *videoURL) {[weakSelf handleRecordFinish:videoURL];}];
    [_cameraManager setBrightnessValueBlock:^(CGFloat brightnessValue) {
        [weakSelf handleBrightness:brightnessValue];
    }];
    
    _cameraView = [[DDYCameraView alloc] initWithFrame:self.view.bounds];
    [_cameraView setBackBlock:^{[weakSelf handleBack];}];
    [_cameraView setToneBlock:^(BOOL isOn) {[weakSelf handleTone:isOn];}];
    [_cameraView setLightBlock:^(BOOL isRecording, BOOL isOn) {[weakSelf handleLight:isOn isRecording:isRecording];}];
    [_cameraView setToggleBlock:^{[weakSelf handleToggle];}];
    [_cameraView setTakeBlock:^{[weakSelf handleTake];}];
    [_cameraView setRecordBlock:^(BOOL isStart) {[weakSelf handleRecord:isStart];}];
    [_cameraView setFocusBlock:^(CGPoint point) {[weakSelf handleFocus:point];}];
    [self.view addSubview:_cameraView];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.cameraManager ddy_StartCaptureSession];
    [self hiddenStatusBar:YES];
    [self.cameraView ddy_ResetRecordView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.cameraManager ddy_StopCaptureSession];
    [self hiddenStatusBar:NO];
    [self.scanView removeTimer];
}

// MARK: - UI事件响应
// MARK: 返回
- (void)handleBack {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

// MARK: 曝光模式
- (void)handleTone:(BOOL)isOn {
    [self.cameraManager ddy_ISO:isOn];
}

// MARK: 闪光灯模式
- (void)handleLight:(BOOL)isOn isRecording:(BOOL)isRecording {
    if (isRecording) {
         [self.cameraManager ddy_SetTorchMode:isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    } else {
         [self.cameraManager ddy_SetFlashMode:isOn ? AVCaptureFlashModeOn : AVCaptureFlashModeOff];
    }
}

// MARK: 切换摄像头
- (void)handleToggle {
    [self.cameraManager ddy_ToggleCamera];
}

// MARK: 拍照
- (void)handleTake {
    [self.cameraManager ddy_TakePhotos];
}

// MARK: 录制开始与结束
- (void)handleRecord:(BOOL)isStart {
    isStart ? [self.cameraManager ddy_StartRecorder] : [self.cameraManager ddy_StopRecorder];
}

// MARK: 点击聚焦
- (void)handleFocus:(CGPoint)point {
    [self.cameraManager ddy_FocusAtPoint:point];
}

// MARK: - cameraManger 回调
// MARK: 拍照成功
- (void)handleTakeFinish:(UIImage *)image {
    if (image && self.takePhotoBlock) {
        self.takePhotoBlock(image, self);
    }
}

// MARK: 录制成功
- (void)handleRecordFinish:(NSURL *)videoURL {
    [self.cameraManager ddy_ResetRecorder];
    if (self.recordVideoBlock) {
        self.recordVideoBlock(videoURL, self);
    }
}

// MARK: 光强检测
- (void)handleBrightness:(CGFloat)brightnessValue {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (brightnessValue > 0 && self.cameraView.isShowToneButton) {
           self.cameraView.isShowToneButton = NO;
        } else if (brightnessValue < 0 && !self.cameraView.isShowToneButton) {
            self.cameraView.isShowToneButton = YES;
        }
    });
}

// MARK: - 状态栏显隐性
- (void)hiddenStatusBar:(BOOL)sender {
    _statusBarHidden = sender;
    [self setNeedsStatusBarAppearanceUpdate];
}
// MARK: 显隐性
- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

@end
