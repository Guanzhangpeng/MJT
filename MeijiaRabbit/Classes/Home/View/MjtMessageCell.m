//
//  MjtMessageCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/29.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageCell.h"
#import "MjtMessageModel.h"

@interface MjtMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;


@end
@implementation MjtMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 8;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
   frame.origin.y += 15;
   frame.size.height -= 15;
   frame.size.width -= 30;
   [super setFrame:frame];
}
-(void)setModel:(MjtMessageModel *)model{
    _model = model;
    self.titleLbl.text = model.message_title;
    self.timeLbl.text = model.create_time;
    self.addressLbl.text = model.address;
}
@end
