//
//  MjtServiceCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceCell.h"
#import "MjtBaseButton.h"
@interface MjtServiceCell()
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTxt;
@property (weak, nonatomic) IBOutlet MjtBaseButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation MjtServiceCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setupSubviews];
}
- (void)_setupSubviews{
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor grayColor].CGColor;
}
@end
