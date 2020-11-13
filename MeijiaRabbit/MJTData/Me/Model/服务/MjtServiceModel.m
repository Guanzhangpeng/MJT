//
//  MjtServiceModel.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/30.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceModel.h"
#import "MJExtension.h"
@implementation MjtServiceModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"desc":@"description"};
}
@end
