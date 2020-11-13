//
//  MjtFindServiceCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/4.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtFindServiceCell.h"
#import "MjtFindServiceModel.h"
#import "UIImageView+WebCache.h"
@interface MjtFindServiceCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
@implementation MjtFindServiceCell
-(void)setModel:(MjtFindServiceModel *)model{
    _model = model;
    self.titleLbl.text = model.name;
    [self.iconImg sd_setImageWithURL: [NSURL URLWithString:model.icon]];
}

@end
