//
//  MjtFindServiceModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/8.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtFindServiceModel : NSObject
//"id": "8",
//"name": "墙面粉刷",
//"pid": "1",
//"icon": "http://192.168.8.174/userapi/serviceclass/icon/4.png",
//"imsges": [
//
//]
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSArray *images;
@end

NS_ASSUME_NONNULL_END
