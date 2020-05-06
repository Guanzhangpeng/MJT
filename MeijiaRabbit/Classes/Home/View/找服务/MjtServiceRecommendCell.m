//
//  MjtServiceRecommendCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceRecommendCell.h"

@interface MjtServiceRecommendCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;

@end
@implementation MjtServiceRecommendCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.cartButton.backgroundColor = MJTGlobalMainColor;
}

@end
