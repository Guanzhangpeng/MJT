//
//  MjtFindServiceCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/4.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtFindServiceCell.h"

@interface MjtFindServiceCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
@implementation MjtFindServiceCell
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.titleLbl.text = dict[@"title"];
    self.iconImg.image = [UIImage imageNamed:dict[@"icon"]];
}

@end
