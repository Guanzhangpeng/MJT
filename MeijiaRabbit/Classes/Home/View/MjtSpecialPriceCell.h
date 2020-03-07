//
//  MyCell.h
//  WMZBanner
//
//  Created by wmz on 2019/9/6.
//  Copyright © 2019 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MjtSpecialPriceCell : UICollectionViewCell
@property(nonatomic,weak) UILabel *titleLbl;///标题
@property(nonatomic,weak) UILabel *originalPriceLbl;///原价
@property(nonatomic,weak) UILabel *currentPricelLbl;///现价
@property(nonatomic,weak) UILabel *tagLabel;///标签
@property(nonatomic,weak) UIImageView *iconImg;///配图
@end

NS_ASSUME_NONNULL_END
