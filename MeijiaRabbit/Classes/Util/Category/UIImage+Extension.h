//
//  UIImage+Extension.h
//  HuangtaijiDingcan
//
//  Created by WangJian on 15/7/6.
//  Copyright (c) 2015年 Microfastup Corps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
- (UIImage *)rotatedImageWithOrientation:(UIImageOrientation)orientation;
/**
 *  Capture image from view whthin a rect
 *
 *  @param view The view which will be captured
 *  @param rect The rect of captured area in the view.
 *
 *  @return Captured image.
 */
+ (UIImage *)captureImageFromView:(UIView *)view inRect:(CGRect)rect;

/**
 *  Save image to file path
 *
 *  @param filePath file path
 *
 *  @return YES, if save successed. NO, if not.
 */

+(UIImage*) imageWithColor:(UIColor*)color;


- (BOOL)saveToPath:(NSString *)filePath;

/**
 *  Get the resized image with size.
 *
 *  @param size New size image will be resized to.
 *
 *  @return Resized image.
 */
- (UIImage *)resizedImageWithSize:(CGSize)size;

/**
 *  Get the capatured image whthin rect
 *
 *  @param rect The rect of captured area in the image.
 *
 *  @return Capatured image
 */
- (UIImage *)capturedImageInRect:(CGRect)rect;

/**
 *  Get the image whith a normal orientation.
 *
 *  @return The image whith a normal orientation.
 */
- (UIImage *)normalOrientationImage;

#pragma mark - TintColor
- (UIImage *)_imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *)grayImage;


/**
 *  根据图片名称获取一张圆形图片
 *
 *  @param imgName 图片名称
 *  @param border  <#border description#>
 *  @param color   <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)circleImageWithName:(NSString *)imgName borderWidth:(CGFloat)border borderColor:(UIColor *)color;

/**
 *  根据图片名称获取一张圆形图片
 *
 *  @param image  <#image description#>
 *  @param border <#border description#>
 *  @param color  <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)border borderColor:(UIColor *)color;


/**
 将图片做拉伸处理
 */
+ (instancetype)resizeImage:(NSString *)imageName;


@end
