//
//  MjtFindServiceVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/30.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtFindServiceVC.h"
#import "MjtFindServiceCell.h"
#import "MjtPublishServiceVC.h"
@interface MjtFindServiceVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *adImgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *middleView;
@end

@implementation MjtFindServiceVC
static NSString *serviceID = @"MjtFindServiceCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找服务";
}
- (void)_setupSubviews{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self _setupTopView];
    [self _setupMiddleView];
    [self _setupBottomView];
}
- (void)_setupTopView{
    UIImageView *adImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    adImg.image = [UIImage imageNamed:@"service_ad"];
    adImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:adImg];
    self.adImgView = adImg;
}
- (void)_setupMiddleView{
    CGFloat middleX = 20;
    CGFloat middleW = ScreenWidth - middleX*2;
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(middleX, CGRectGetMaxY(self.adImgView.frame) - 2*middleX , middleW , 300)];
    middleView.backgroundColor = MJTColorFromHexString(@"#F7FDFF");
    middleView.layer.cornerRadius = 8;
    [self.scrollView addSubview:middleView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, middleW, 20)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:17];
    titleLbl.text = @"局部装修";
    titleLbl.textColor = MJTColorFromHexString(@"#333333");
    [middleView addSubview:titleLbl];
    
    [middleView addSubview:self.collectionView];
    self.middleView = middleView;
}
- (void)_setupBottomView{
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"装修范围";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:17];
    titleLbl.textColor = MJTColorFromHexString(@"#333333");
    titleLbl.y = CGRectGetMaxY(self.middleView.frame) + 20;
    titleLbl.size = CGSizeMake(70, 25);
    titleLbl.centerX = ScreenWidth/2;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = MJTColorFromHexString(@"#1160B7");
    lineView.size = CGSizeMake(70, 3);
    lineView.y = CGRectGetMaxY(titleLbl.frame) - 5;
    lineView.centerX = ScreenWidth/2;
    

    [self.scrollView addSubview:titleLbl];
    [self.scrollView addSubview:lineView];
    
}
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MjtFindServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceID forIndexPath:indexPath];
    cell.dict = self.dataArray[indexPath.item];
    
    return cell;
}
#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.item];
    MJTLog(dict[@"title"]);
    
    [self.navigationController pushViewController:[MjtPublishServiceVC new] animated:YES];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat w = (ScreenWidth - 40);
        layout.itemSize = CGSizeMake(w/2, 60);
        layout.minimumInteritemSpacing=0;
        layout.minimumLineSpacing=20;
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView左右内边距；
//        layout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50,w , 230) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtFindServiceCell class]) bundle:nil] forCellWithReuseIdentifier:serviceID];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"part.json" ofType:nil];
        NSData *data =  [NSData dataWithContentsOfFile:fileName];
        _dataArray =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return _dataArray;
}
@end
