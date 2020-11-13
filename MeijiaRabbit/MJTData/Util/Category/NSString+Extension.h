//
//  NSString+Extension.h
//
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)




- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  计算当前文件\文件夹的内容大小
 */
- (NSInteger)fileSize;


/**
 将字典转换成字符串

 @param object 传入的字典
 @return 返回的字符串
 */
+(NSString*)DataTOjsonString:(id)object;
/**
 *  截取UTC中的数字    /Date(1440086400000)/
 *
 *  @param urlString 传递进来的UTC字符串，例如：/Date(1440086400000)/
 */
+(NSString * )regexPatten:(NSString * ) urlString;

/**
 *  转换UTC时间1440086400000
 *
 *  @param utcTime 1440086400000
 */
+(NSString * )ChangeTimeFommater:(NSString *) utcTime;


/**
 获取设备型号名称；

 @return 返回设备型号
 */
+ (NSString*)deviceModelName;


+ (NSString *)imageNameWithMac:(NSString *)device_Mac;

/**
获取汉字的拼音

@return 返回拼音
*/
+ (NSString *)transformToPinyin:(NSString *)chinese;


@end
