//
//  MjtMessageModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/29.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MJTMessageType) {
//1:系统消息，2：服务消息
    
    ///系统消息
    MJTMessageSystemType = 1,
    /** 服务消息 */
    MJTMessageServiceType = 2
};

@interface MjtMessageModel : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *ID;
///1:已读，2：未读
@property (nonatomic, assign) NSInteger isread;
@property (nonatomic, strong) NSString *message_title;
@end

NS_ASSUME_NONNULL_END
