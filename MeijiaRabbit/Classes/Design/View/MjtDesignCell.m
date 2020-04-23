//
//  MjtDesignCell.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/20.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtDesignCell.h"

@interface MjtDesignCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *styleLbl;
@property (weak, nonatomic) IBOutlet UILabel *capacityLbl;
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end
@implementation MjtDesignCell

- (IBAction)thumb_Click:(id)sender {
    self.thumbBtn.selected = !_thumbBtn.selected;
    !_thumbAction ?  :_thumbAction();
}

@end
