//
//  MjtShopReadModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/8/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtShopReadModel : NSObject
//"comment_count" = 0;
//mobile = 15600928831;
//"order_count" = 18;
//"return_count" = 0;
//"uncomment_count" = 0;
//"user_id" = 4583;
//waitPay = 0;
//waitReceive = 0;
//waitSend = 18;

@property (nonatomic, assign) int comment_count;
@property (nonatomic, assign) int order_count;
@property (nonatomic, assign) int return_count;///售后数量
@property (nonatomic, assign) int uncomment_count;
@property (nonatomic, assign) int waitPay;
@property (nonatomic, assign) int waitReceive;
@property (nonatomic, assign) int waitSend;
@end

NS_ASSUME_NONNULL_END
