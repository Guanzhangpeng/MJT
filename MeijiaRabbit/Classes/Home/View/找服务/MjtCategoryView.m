//
//  MjtCategoryView.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/7.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtCategoryView.h"
#import "JXCategoryListContainerView.h"
@interface MjtCategoryView()<JXCategoryListContentViewDelegate>

@end
@implementation MjtCategoryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MJTRandomColor;
    }
    return self;
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
@end
