//
//  MjtPublishServiceVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/4.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtPublishServiceVC.h"
#import "MjtBaseButton.h"
#import "Masonry.h"
#import "ImagePickerView.h"
#import "MjtServiceRecommendCell.h"
#define HWStatusPhotoWH  (([UIScreen mainScreen].bounds.size.width - HWStatusPhotoMargin * 4) / 3)
#define HWStatusPhotoMargin (15)
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
@interface MjtPublishServiceVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *recommendLbl;
@end

@implementation MjtPublishServiceVC
static NSString *CellID = @"MjtServiceRecommendCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.title = @"发布服务需求";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
- (void)_setupSubviews{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView =scrollView;

    
    CGFloat margin = 15;
    //我的地址
    UILabel *titleLbl1 = [[UILabel alloc] init];
    titleLbl1.text = @"*我的地址";
    titleLbl1.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:titleLbl1];
    [titleLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(margin);
    }];
    
    MjtBaseButton *choseAddressBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [choseAddressBtn setImage:[UIImage imageNamed:@"button_plus"] forState:0];
    [choseAddressBtn addTarget:self action:@selector(_addressChose_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:choseAddressBtn];
    [choseAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).with.offset(-margin);
        make.centerY.mas_equalTo(titleLbl1.mas_centerY);
        make.height.mas_equalTo(30);
    }];
     
    UILabel *addressLbl = [[UILabel alloc] init];
    addressLbl.text = @"北京市朝阳区惠新里3号楼北京市朝阳区惠新里3号楼北京市朝阳区惠新里3号楼";
    addressLbl.numberOfLines = 0;
    addressLbl.textColor = MJTColorFromHexString(@"#999999");
    addressLbl.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl1.mas_bottom).with.offset(8);
        make.left.mas_equalTo(titleLbl1.mas_left).with.offset(8);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
    }];
    
//    服务分类
     UILabel *titleLbl2 = [[UILabel alloc] init];
        titleLbl2.text = @"*请选择服务分类";
        titleLbl2.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:titleLbl2];
        [titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLbl1.mas_left);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(addressLbl.mas_bottom).with.offset(margin);
        }];
        
    MjtBaseButton *choseServiceBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [choseServiceBtn addTarget:self action:@selector(_serviceChose_Click) forControlEvents:UIControlEventTouchUpInside];
    choseServiceBtn.backgroundColor = MJTGlobalMainColor;
    [choseServiceBtn setTitle:@"选择" forState:0];
    [choseServiceBtn setTitleColor:[UIColor blackColor] forState:0];
    choseServiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    choseServiceBtn.layer.cornerRadius = 10;
    [self.scrollView addSubview:choseServiceBtn];
    [choseServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).with.offset(-margin);
        make.width.mas_equalTo(50);
        make.centerY.mas_equalTo(titleLbl2.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *serviceLbl = [[UILabel alloc] init];
    serviceLbl.text = @"地板装修";
    serviceLbl.numberOfLines = 0;
    serviceLbl.textColor = MJTColorFromHexString(@"#999999");
    serviceLbl.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:serviceLbl];
    [serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl2.mas_bottom).with.offset(8);
        make.left.mas_equalTo(titleLbl1.mas_left).with.offset(8);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
    }];
    
    //具体需求描述
    UILabel *titleLbl3 = [[UILabel alloc] init];
       titleLbl3.text = @"*具体需求描述";
       titleLbl3.font = [UIFont systemFontOfSize:14];
       [self.scrollView addSubview:titleLbl3];
       [titleLbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(titleLbl1.mas_left);
           make.width.mas_equalTo(110);
           make.height.mas_equalTo(21);
           make.top.mas_equalTo(serviceLbl.mas_bottom).with.offset(margin);
       }];
    
    UITextView *descTxt = [[UITextView alloc] init];
    descTxt.font = [UIFont systemFontOfSize:13];
    descTxt.backgroundColor = [UIColor whiteColor];
    descTxt.layer.cornerRadius = 8;
    descTxt.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
    [scrollView addSubview:descTxt];
    [descTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl1.mas_left);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
        make.height.mas_equalTo(85);
        make.top.mas_equalTo(titleLbl3.mas_bottom).with.offset(margin);
    }];
    
    //上传现场改造图片
    UILabel *titleLbl4 = [[UILabel alloc] init];
       titleLbl4.text = @"上传改造现场图片";
       titleLbl4.font = [UIFont systemFontOfSize:14];
       [self.scrollView addSubview:titleLbl4];
       [titleLbl4 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(titleLbl1.mas_left);
           make.width.mas_equalTo(140);
           make.height.mas_equalTo(21);
           make.top.mas_equalTo(descTxt.mas_bottom).with.offset(margin);
       }];
    
    ImagePickerView *imgPickerVC = [[ ImagePickerView alloc] init];
    //图片选择器 最大数量
      NSInteger maxImagesCount = 9;
    __weak typeof(imgPickerVC) weakPickerVC = imgPickerVC;
    imgPickerVC.didFinishPickingPhotos = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSInteger imgCount = (photos.count == maxImagesCount ? maxImagesCount : photos.count + 1);
        CGSize imgViewSize = [self sizeWithCount:imgCount];
        [weakPickerVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imgViewSize.height);
        }];
    };
    imgPickerVC.maxImagesCount = maxImagesCount;
    imgPickerVC.columnNumber = 4;
    [self addChildViewController:imgPickerVC];
    [self.scrollView addSubview:imgPickerVC.view];
    [imgPickerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl4.mas_bottom).with.offset(margin);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(HWStatusPhotoWH + margin);
    }];
    
    //推荐
    UILabel *titleLbl5 = [[UILabel alloc] init];
   titleLbl5.text = @"根据您的需要，为您精心推荐以下产品：";
   titleLbl5.font = [UIFont systemFontOfSize:14];
   [self.scrollView addSubview:titleLbl5];
   [titleLbl5 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(titleLbl1.mas_left);
       make.right.mas_equalTo(self.view.mas_right).with.offset(-margin);
       make.height.mas_equalTo(21);
       make.top.mas_equalTo(imgPickerVC.view.mas_bottom).with.offset(margin);
   }];
    self.recommendLbl = titleLbl5;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    margin = 25;
    CGFloat itemW = (ScreenWidth - margin *2 - 30)/2;
    layout.itemSize = CGSizeMake(itemW, 120);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 30;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtServiceRecommendCell class]) bundle:nil] forCellWithReuseIdentifier:CellID];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(titleLbl5.mas_bottom).with.offset(margin);
        make.height.mas_equalTo(280);
    }];
    
    //提交需求
    MjtBaseButton *submitBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交需求" forState:0];
    [submitBtn setTitleColor:[UIColor blackColor] forState:0];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.backgroundColor = MJTGlobalMainColor;
    submitBtn.layer.cornerRadius = 8;
    [submitBtn addTarget:self action:@selector(_submitButton_Click) forControlEvents:UIControlEventTouchUpOutside];
    [self.scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(25);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.collectionView.mas_bottom).with.offset(margin);
        
    }];
     [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
         make.bottom.mas_equalTo(submitBtn.mas_bottom).with.offset(50);
     }];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MjtServiceRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    return cell;
}
#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -- 点击事件
- (void)_addressChose_Click{
    
}
- (void)_serviceChose_Click{
    
}
- (void)_submitButton_Click{
    
}
- (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = HWStatusPhotoMaxCol(count);
    
//    NSUInteger cols = (count >= maxCols)? maxCols : count;
    
    CGFloat photosW = [UIScreen mainScreen].bounds.size.width;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    
    CGFloat photosH = rows * HWStatusPhotoWH + (rows + 1) * HWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}
@end
