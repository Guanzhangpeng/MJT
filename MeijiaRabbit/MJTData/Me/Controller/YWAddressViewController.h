//
//  YWAddressViewController.h
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWAddressInfoModel.h"

typedef void(^AddressBlock)(YWAddressInfoModel *model);

@interface YWAddressViewController : UIViewController
/** 如果为编辑地址则需传入model **/
@property (nonatomic, strong) YWAddressInfoModel         * model;

/** 保存收货地址信息后的地址信息回调 **/
@property (nonatomic, strong) AddressBlock                   addressBlock;

@property (nonatomic, assign) BOOL isEditing;//是否是编辑地址;

@property(nonatomic,strong) NSMutableArray *titleIDMarr;
@end
