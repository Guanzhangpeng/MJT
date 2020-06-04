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
#import "MJExtension.h"
#import "MjtRangeModel.h"
#import "BRAddressModel.h"
#import "JXCategoryView.h"
#import "Masonry.h"
#import "MjtCategoryView.h"
#import "MjtBaseButton.h"
#import "MjtFindServiceModel.h"
#import "MJExtension.h"
#import "MjtLoginVC.h"
#define Margin (20)
#define ItemH (60)
@interface MjtFindServiceVC ()<UICollectionViewDelegate,UICollectionViewDataSource,JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *adImgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<MjtFindServiceModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<MjtFindServiceModel *> *dataArray2;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSString *topTitle;
@property (nonatomic, strong) NSString *bottomTitle;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MjtFindServiceVC
static NSString *serviceID = @"MjtFindServiceCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _loadData];
}

- (void)_loadData{
    WeakSelf;
    [NetBaseTool postWithUrl:MJT_Find_SERVICE_List_PATH params:nil decryptResponse:NO showHud:NO success:^(NSArray *responseArray) {
        if (responseArray.count == 2) {
            self.topTitle =  responseArray[0][@"title"];
            self.bottomTitle = responseArray[1][@"title"];
            weakSelf.dataArray = [MjtFindServiceModel mj_objectArrayWithKeyValuesArray:responseArray[0][@"cates"]];
            weakSelf.dataArray2 = [MjtFindServiceModel mj_objectArrayWithKeyValuesArray:responseArray[1][@"cates"]];
            weakSelf.titles = [NSMutableArray array];
            for (MjtFindServiceModel *model in weakSelf.dataArray2) {
                [weakSelf.titles addObject:model.name];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           [self _setupSubviews];
        });
    } failure:^(NSError *error) {
        
    }];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找服务";
}
- (void)_setupSubviews{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self _setupTopView];
}
- (void)_setupTopView{
    UIImageView *adImg = [[UIImageView alloc] init];
    adImg.image = [UIImage imageNamed:@"service_ad"];
    adImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:adImg];
    self.adImgView = adImg;
    [self.adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    //局部装修
    UIView *middleView = [[UIView alloc] init];
    
    middleView.backgroundColor =MJTColorFromHexString(@"#F7FDFF");
    middleView.layer.cornerRadius = 8;
    [self.scrollView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(Margin);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-Margin);
        make.top.mas_equalTo(self.adImgView.mas_bottom).with.offset(-Margin*2);
        make.height.mas_equalTo(230);
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont boldSystemFontOfSize:17];
    titleLbl.text = @"局部装修";
    titleLbl.textColor = MJTColorFromHexString(@"#333333");
    [middleView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(middleView);
        make.top.mas_equalTo(Margin/2);
        make.height.mas_equalTo(20);
    }];
    
    [middleView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(middleView);
        make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(Margin);
        make.bottom.mas_equalTo(middleView.mas_bottom).with.offset(-Margin);
    }];
    
    //折叠
    MjtBaseButton *showButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [showButton setImage:[UIImage imageNamed:@"down"] forState:0];
    [showButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [showButton addTarget:self action:@selector(_showButton_Click:) forControlEvents:UIControlEventTouchUpInside];
    [showButton setTitleColor:MJTColorFromHexString(@"666666") forState:0];
    showButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [showButton setTitle:@"展开" forState:0];
    [showButton setTitle:@"折叠" forState:UIControlStateSelected];
    [middleView addSubview:showButton];
    [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(middleView.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(middleView.mas_right);
        make.width.mas_equalTo(120);
    }];
    self.middleView = middleView;
    
    //装修范围
    UILabel *titleLbl2 = [[UILabel alloc] init];
   titleLbl2.text = @"装修范围";
   titleLbl2.textAlignment = NSTextAlignmentCenter;
   titleLbl2.font = [UIFont boldSystemFontOfSize:17];
   titleLbl2.textColor = MJTColorFromHexString(@"#333333");
    [self.scrollView addSubview:titleLbl2];
    [titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(Margin);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
   
   
   UIView *line = [[UIView alloc] init];
   line.backgroundColor = MJTColorFromHexString(@"#1160B7");
   [self.scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(70);
        make.top.mas_equalTo(titleLbl2.mas_bottom).offset(-3);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
   
   [self.scrollView addSubview:self.categoryView];
   [self.scrollView addSubview:self.listContainerView];
   self.categoryView.listContainer = self.listContainerView;
   self.categoryView.delegate = self;
    self.categoryView.titleColorGradientEnabled = YES;
     JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = 20;//JXCategoryViewAutomaticDimension;
    //    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
        self.categoryView.indicators = @[lineView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(line.mas_bottom);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(25);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-25);
        make.height.mas_equalTo(150);
        make.top.mas_equalTo(self.categoryView.mas_bottom).with.offset(10);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.listContainerView.mas_bottom).with.offset(Margin);
    }];
    
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MjtFindServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
}
#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![MjtUserInfo sharedUser].isLogin) {
        MjtLoginVC *loginVC = [[MjtLoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    MjtFindServiceModel *model = self.dataArray[indexPath.item];
    MJTLog(@"%@",model.name);
    MjtPublishServiceVC *publishVC = [[MjtPublishServiceVC alloc] init];
    publishVC.serviceModel = model;
    [self.navigationController pushViewController:publishVC animated:YES];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MjtFindServiceModel *model = self.dataArray2[index];
    MjtCategoryView *categoryView = [[MjtCategoryView alloc] init];
    categoryView.model = model;
    WeakSelf;
    categoryView.tapAction = ^{
        if (![MjtUserInfo sharedUser].isLogin) {
            MjtLoginVC *loginVC = [[MjtLoginVC alloc] init];
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        MjtPublishServiceVC *publishVC = [[MjtPublishServiceVC alloc] init];
        publishVC.serviceModel = model;
        [weakSelf.navigationController pushViewController:publishVC animated:YES];
    };
    return categoryView;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat w = (ScreenWidth - 40);
        layout.itemSize = CGSizeMake(w/2, ItemH);
        layout.minimumInteritemSpacing=0;
        layout.minimumLineSpacing=Margin;
        
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView左右内边距；
//        layout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MjtFindServiceCell class]) bundle:nil] forCellWithReuseIdentifier:serviceID];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = self.titles;
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}
#pragma mark -- 点击事件
- (void)_showButton_Click:(MjtBaseButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        //计算总高度 10 + 20 + 20 + 20 + Margin*
//        (totalRecord  +  pageSize  - 1) / pageSize;
        CGFloat height = 10 + 20 + (Margin + ItemH)*(self.dataArray.count + 2 - 1 )/2;
        [UIView animateWithDuration:0.3 animations:^{
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        }];


    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(230);
            }];
        }];
    }
}
@end
