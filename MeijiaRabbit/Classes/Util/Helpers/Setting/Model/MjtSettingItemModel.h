//
//  MjtSettingItemModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/12.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MJTSettingAccessoryType) {
    MJTSettingAccessoryTypeNone,///don't show any accessory type
    MJTSettingAccessoryTypeDisclosureIndicator,/// the same with system DisclosureIndicator
    MJTSettingAccessoryTypeSwitch,///  swithch
};
NS_ASSUME_NONNULL_BEGIN

@interface MjtSettingItemModel : NSObject
@property (nonatomic, strong) NSString  *funcName;     /**<      功能名称*/
@property (nonatomic, strong) UIImage *img;          /**< 功能图片  */
@property (nonatomic, strong) NSString *detailText;    /**< 更多信息-提示文字  */
@property (nonatomic, strong) UIImage *detailImage;  /**< 更多信息-提示图片  */


@property (nonatomic,assign) MJTSettingAccessoryType  accessoryType;    /**< accessory */
@property (nonatomic,copy) void (^executeCode)(); /**<      点击item要执行的代码*/
@property (nonatomic,copy) void (^switchValueChanged)(BOOL isOn); /**<  XBSettingAccessoryTypeSwitch下开关变化 */
@end

NS_ASSUME_NONNULL_END
