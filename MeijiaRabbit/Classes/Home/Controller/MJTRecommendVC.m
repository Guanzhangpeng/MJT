//
//  MJTRecommendVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/22.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MJTRecommendVC.h"
#import "DDYCamera.h"
@interface MJTRecommendVC ()

@end

@implementation MJTRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    __weak __typeof (self)weakSelf = self;
    [DDYCameraManager ddy_CameraAuthSuccess:^{
        [DDYCameraManager ddy_MicrophoneAuthSuccess:^{
            DDYCameraController *cameraVC = [[DDYCameraController alloc] init];
            [cameraVC setTakePhotoBlock:^(UIImage *image, UIViewController *vc) {
                __strong __typeof (weakSelf)strongSelf = weakSelf;
//                strongSelf.imageView.image = image;
                [vc dismissViewControllerAnimated:YES completion:^{ }];
            }];
            [cameraVC setRecordVideoBlock:^(NSURL *videoURL, UIViewController *vc) {
                __strong __typeof (weakSelf)strongSelf = weakSelf;
//                [strongSelf.player playWithPath:videoURL.absoluteString];
                [vc dismissViewControllerAnimated:YES completion:^{ }];
            }];
            [self presentViewController:cameraVC animated:YES completion:^{ }];
        } fail:^{NSLog(@"麦克风权限未开启");}];
    } fail:^{NSLog(@"相机权限未开启");}];
}
- (void)_setup{
    self.title = @"人脸智能推荐";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)_setupSubviews{
    
}
@end
