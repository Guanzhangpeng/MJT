//
//  STButton.m
//  kdzs
//
//  Created by 管章鹏 on 2018/8/17.
//  Copyright © 2018年 gzp. All rights reserved.
//

#import "MjtButton.h"

@interface MjtButton()

@end
@implementation MjtButton

-(void)setImageWH:(CGFloat)imageWH{
    _imageWH = imageWH;
    self.imageView.frame = CGRectMake((self.width - _imageWH)/2, 0.f, _imageWH, _imageWH);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+_margin , self.width, self.height - _imageWH- _margin);
}
-(void)setMargin:(CGFloat)margin{
    _margin = margin;
    self.imageView.frame = CGRectMake((self.width - _imageWH)/2, 0.f, _imageWH, _imageWH);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+_margin , self.width, self.height - _imageWH- _margin);
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.margin = 5;
        self.imageWH = 36;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((self.width - self.imageWH)/2, 0.f, self.imageWH, self.imageWH);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+_margin , self.width, self.height - _imageWH- _margin);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}
-(void)setHighlighted:(BOOL)highlighted{}
@end
