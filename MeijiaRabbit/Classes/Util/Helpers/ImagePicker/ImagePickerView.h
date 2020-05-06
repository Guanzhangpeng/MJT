//
//  ImagePickerView.h
//  TZImagePickerController
//
//  Created by 管章鹏 on 2017/11/14.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagePickerView : UIViewController


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) void(^didFinishPickingPhotos)(NSArray<UIImage *> *photos ,NSArray *assets ,BOOL isSelectOriginalPhoto);

@property (nonatomic, strong, readonly) NSMutableArray *selectedPhotos;// 选择的图片

@property (nonatomic, assign, readonly)  CGFloat itemWH; //cell的宽高
@property (nonatomic, assign, readonly)  CGFloat itemMargin;//cell之间的间距

@property (nonatomic, strong, readonly) NSMutableArray *selectedAssets;

/// Default is NO / 默认为NO，为YES时可以多选视频/gif图片，和照片共享最大可选张数maxImagesCount的限制
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;

/// Default is YES, if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

@property (nonatomic, assign) BOOL allowCrop;//是否允许裁剪
@property (nonatomic, assign) BOOL needCircleCrop;       ///< 需要圆形裁剪框
@property (nonatomic, assign) BOOL isAllowPickingGif; //是否允许选择GIF图片
@property (nonatomic, assign) NSInteger maxImagesCount; //最多允许选择图片的数量
@property (nonatomic, assign) NSInteger columnNumber; //图片选择器的列数量

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;
@end
