//
//  ProvinceModel.h
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2017/12/18.
//  Copyright © 2017年 张海峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
//@property(nonatomic,copy)NSString *created_time;
//@property(nonatomic,assign)NSInteger id;
//@property(nonatomic,assign)NSInteger is_enabled;
//@property(nonatomic,copy)NSString *province_name;
//@property(nonatomic,assign)NSInteger seq_no;
//@property(nonatomic,copy)NSString *updated_time;
//@property(nonatomic,assign)NSInteger updated_user;


@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger parentid;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
@property(nonatomic,copy)NSString *name;
//id = 120100;
//latitude = "39.125595";
//longitude = "117.190186";
//name = "\U5929\U6d25\U5e02";
//parentid = 120000;

@end
