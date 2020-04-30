//
//  MjtServiceCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtServiceCell.h"
#import "MjtBaseButton.h"
#import "MjtServiceModel.h"
@interface MjtServiceCell()
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTxt;//代付款 代开工....
@property (weak, nonatomic) IBOutlet MjtBaseButton *detailButton;//查看详情
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;//发布时间
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLbl;//服务类别
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;//详细需求
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
-(void)setModel:(MjtServiceModel *)model{
    _model = model;
    self.orderStatusTxt.text = model.service_order_status_name;
    self.timeLbl.text = model.create_time;
    self.orderTypeLbl.text = model.service_name;
    self.detailLbl.text = model.desc;
}
@end
