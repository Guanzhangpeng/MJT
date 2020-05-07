//
//  HomeViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/3/5.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "HomeViewController.h"
#import "WMZBannerView.h"
#import "Masonry.h"
#import "MjtView.h"
#import "MjtGuideView.h"
#import "MjtSpecialPriceCell.h"
#import "MjtTipView.h"
#import "MjtRecommendView.h"
#import "UIImage+Extension.h"
#import "MjtBaseButton.h"
#import "JFCitySelector.h"
#import "MjtMessageBaseVC.h"
#import "MjtDiscountListVC.h"
#import "NSDictionary+YYAdd.h"
#import "MjtFindServiceVC.h"

#define RSA_Public_key @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCJUIlZwVc8gBL4q1/GjwXnTgCq+PO72t1lj9kBVLcHMm8Pko68YKsrNEEkSnEckwVaoRj9WhSP262uSm73SNhLwQsCue8YznzI3UAjuM69AuYt5afYlFiOrcw7QK0rFWAMCZBJn/OQBGD9h1jBRUb9Vi+7MZxLCQN+JrBW4T87OQIDAQAB"

@interface HomeViewController ()<JFCSTableViewControllerDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topScrollAdView;///顶部轮播图
@property (nonatomic, weak) UIView *mainFunView;///主功能
@property (nonatomic, weak) MjtGuideView *guideView;///装修流程
@property (nonatomic, weak) UIView *specialPriceView;///每日特价

@property (nonatomic, strong) MjtBaseButton *locationBtn;
@end

@implementation HomeViewController

#pragma mark --系统回调方法
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#FFCE00")] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attrs = @{ NSStrokeWidthAttributeName: @(0),
                             NSFontAttributeName: [UIFont systemFontOfSize:16],
                             NSForegroundColorAttributeName:MJTColorFromHexString(@"#333333")};
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    NSDictionary *attrs = @{ NSStrokeWidthAttributeName: @(0),
                             NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                             NSForegroundColorAttributeName:MJTColorFromHexString(@"#333333")};
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
}
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title  = @"美嘉兔";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LocationCity:) name:@"LOCATION_CITY" object:nil];
}
- (void)LocationCity:(NSNotification *)noti{
    NSString *city = noti.userInfo[@"CurrentCity"];
    [self.locationBtn setTitle:city forState:0];
}
- (void)_setupNavigationItem{
    
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    MjtBaseButton *addressBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, 0, 85, 22);
    [addressBtn setImage:[UIImage imageNamed:@"nav_location"] forState:UIControlStateNormal];
    [addressBtn setTitle:city forState:UIControlStateNormal];
    addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    addressBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [addressBtn addTarget:self action:@selector(_addressClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addressBtn];
    self.locationBtn = addressBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(_messageClick)];
    

    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)_setupSubViews{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0);
    [self _setupTopScrollAdView];//顶部轮播图
    [self _setupMainFunView];//主功能
    [self _setupFitmentFlowView];//装修流程
    [self _setupSpecialPrice];///每日特价
    [self _setupRecommendView];///案例推荐
}

- (void)_setupTopScrollAdView{
  
  WMZBannerParam *param =  BannerParam()
  .wFrameSet(CGRectMake(MJTGlobalViewLeftInset, 0, ScreenWidth - MJTGlobalViewLeftInset *2, 160))
  //传入数据
  .wDataSet([self getData])
    .wBannerControlImageSet(@"control_normal")
    .wBannerControlSelectImageSet(@"control_selected")
    .wBannerControlImageSizeSet(CGSizeMake(8, 8))
    .wBannerControlSelectImageSizeSet(CGSizeMake(16, 4))
    //自定义pageControl的位置
//    .wCustomControlSet(^(UIPageControl *pageControl) {
//        //随意改变xy值
//        CGRect rect = pageControl.frame;
//        rect.origin.y =  10;
//        pageControl.frame = rect;
//    })
  //开启循环滚动
  .wRepeatSet(YES)
  //开启自动滚动
  .wAutoScrollSet(YES)
  //自动滚动时间
  .wAutoScrollSecondSet(3)
//  .wEventClickSet(^(id anyID, NSIndexPath *path) {
//      NSLog(@"点击 %@ %@",anyID,path);
//  })
  ;
  self.topScrollAdView =  [[WMZBannerView alloc] initConfigureWithModel:param withView:self.scrollView];
}
///主入口
- (void)_setupMainFunView{
    WeakSelf;
    UIView *mainfunView;
    [self.scrollView addSubview:({
         mainfunView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topScrollAdView.frame) + MJTGlobalViewLeftInset, ScreenWidth, 140.f)];
        mainfunView;
    })];
    self.mainFunView = mainfunView;
    /// DIY
    MjtView *diyView = [[MjtView alloc] init];
    [mainfunView addSubview:diyView];
    [diyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(mainfunView);
        make.left.mas_equalTo(2*MJTGlobalViewTopInset);
        make.right.mas_equalTo(mainfunView.mas_centerX).offset(-MJTGlobalViewLeftInset *0.5);
    }];
    diyView.bgView.image = [UIImage imageNamed:@"home_diy_bg"];
    diyView.textLabel.text = @"DIY家装设计";
    diyView.detailtextLabel.text = @"自己动手设计家";
    diyView.detailtextLabel.textColor = MJTColorFromHexString(@"#5272C6");
    diyView.iconView.image = [UIImage imageNamed:@"home_diy"];
    [diyView.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(diyView).offset(-5);
        make.right.mas_equalTo(diyView).offset(-5);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(51);
    }];
    diyView.clickBlock = ^{
        MJTLog(@"DIY点击");
    };
    /// 找服务
     MjtView *serviceView = [[MjtView alloc] init];
    [mainfunView addSubview:serviceView];
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainfunView);
        make.height.mas_equalTo(65);
        make.right.mas_equalTo(-2*MJTGlobalViewTopInset);
        make.left.mas_equalTo(mainfunView.mas_centerX).offset(MJTGlobalViewLeftInset *0.5);
    }];
    serviceView.bgView.image = [UIImage imageNamed:@"home_servive_bg"];
    serviceView.textLabel.text = @"找服务";
    serviceView.iconView.image = [UIImage imageNamed:@"home_servive"];
    [serviceView.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(serviceView).offset(-3);
        make.right.mas_equalTo(serviceView).offset(-3);
        make.width.mas_equalTo(49);
        make.height.mas_equalTo(47);
    }];
    serviceView.clickBlock = ^{
        MJTLog(@"找服务点击");
        [weakSelf.navigationController pushViewController:[MjtFindServiceVC new] animated:YES];
    };
    
    
    /// 施工保障
    MjtView *guaranteeView = [[MjtView alloc] init];
    [mainfunView addSubview:guaranteeView];
    [guaranteeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(mainfunView);
        make.height.mas_equalTo(65);
        make.right.mas_equalTo(-2*MJTGlobalViewTopInset);
        make.left.mas_equalTo(mainfunView.mas_centerX).offset(MJTGlobalViewLeftInset *0.5);
    }];
    guaranteeView.bgView.image = [UIImage imageNamed:@"home_safeguard_bg"];
    guaranteeView.textLabel.text = @"施工保障";
    guaranteeView.detailtextLabel.text = @"家装托管";
    guaranteeView.detailtextLabel.textColor = MJTColorFromHexString(@"#666666");
    guaranteeView.iconView.image = [UIImage imageNamed:@"home_safeguard"];
    [guaranteeView.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(guaranteeView).offset(-3);
        make.right.mas_equalTo(guaranteeView).offset(-3);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(47);
    }];
    guaranteeView.clickBlock = ^{
        MJTLog(@"施工保障点击");
    };
    
    
}

///装修流程
- (void)_setupFitmentFlowView{
    MjtGuideView *guidView = [[MjtGuideView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainFunView.frame) + 2*MJTGlobalViewLeftInset, ScreenWidth, 100)];
//    guidView.backgroundColor = MJTRandomColor;
    guidView.detailBlock = ^{
        MJTLog(@"装修流程");
    };
    [self.scrollView addSubview:guidView];
    self.guideView = guidView;
}

///每日特价
- (void)_setupSpecialPrice{
    UIView *specialPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.guideView.frame) + MJTGlobalViewLeftInset, ScreenWidth, 230)];
    [self.scrollView addSubview:specialPriceView];
    MjtTipView *tipView = [[MjtTipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    tipView.tipLabel.text = @"每日特价";
    [specialPriceView addSubview:tipView];
//    specialPriceView.backgroundColor = MJTRandomColor;
    self.specialPriceView = specialPriceView;
    
    WMZBannerParam *param =
       BannerParam()
       //自定义视图必传
       .wMyCellClassNameSet(@"MjtSpecialPriceCell")
       .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
                  //自定义视图
           MjtSpecialPriceCell *cell = (MjtSpecialPriceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MjtSpecialPriceCell class]) forIndexPath:indexPath];
           cell.titleLbl.text = model[@"title"];
           cell.currentPricelLbl.text = model[@"currentPricel"];
//           cell.originalPriceLbl.text = model[@"originalPrice"];
           cell.tagLabel.text = model[@"tag"];
           
           NSAttributedString *attrStr =
              [[NSAttributedString alloc] initWithString:model[@"originalPrice"]
                                            attributes:
              @{
                NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName:MJTColorFromHexString(@"#333333")}];
                  
              cell.originalPriceLbl.attributedText = attrStr;
           
           
           [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]] placeholderImage:nil];
           return cell;
       })
       .wFrameSet(CGRectMake(0, 20, BannerWitdh,200))
       .wDataSet([self getData])
       //关闭pageControl
       .wHideBannerControlSet(YES)
       //开启缩放
       .wScaleSet(YES)
       //自定义item的大小
       .wItemSizeSet(CGSizeMake(BannerWitdh*0.8, 160))
       //固定移动的距离
       .wContentOffsetXSet(0.5)
       //循环
       .wRepeatSet(YES)
       //中间cell层级最上面
       .wZindexSet(YES)
       //整体左右间距  设置为size.width的一半 让最后一个可以居中
       .wSectionInsetSet(UIEdgeInsetsMake(0,10, 0, BannerWitdh*0.55*0.3))
       //间距
       .wLineSpacingSet(10)
       //开启背景毛玻璃
       .wEffectSet(NO)
    .wEventCenterClickSet(^(id anyID, NSInteger index,BOOL isCenter,UICollectionViewCell *cell) {
        [self.navigationController pushViewController:[MjtDiscountListVC new] animated:YES];
    })
//       点击左右居中
//       .wEventCenterClickSet(YES)
       ;
       WMZBannerView *bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
       [specialPriceView addSubview:bannerView];
}

///案例推荐
- (void)_setupRecommendView{
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.specialPriceView.frame) + MJTGlobalViewLeftInset, ScreenWidth, 18+12+98+12+98)];
       [self.scrollView addSubview:recommendView];
       MjtTipView *tipView = [[MjtTipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
       tipView.tipLabel.text = @"案例推荐";
       [recommendView addSubview:tipView];
    
    MjtRecommendView *recommendView1 = [[MjtRecommendView alloc] init];
    recommendView1.backgroundColor = MJTRandomColor;
//    recommendView1.bgImgView.image = [UIImage imageNamed:@""];
    [recommendView1.bgImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg"] placeholderImage:nil];
    recommendView1.titleLbl.text = @"水电";
    recommendView1.detailLbl.text = @"水电改造·管道封闭";
    [recommendView addSubview:recommendView1];
    [recommendView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MJTGlobalViewLeftInset);
        make.right.mas_equalTo(-MJTGlobalViewLeftInset);
        make.height.mas_equalTo(98);
        make.top.mas_equalTo(tipView.mas_bottom).with.offset(MJTGlobalViewTopInset);
    }];
    
    MjtRecommendView *recommendView2 = [[MjtRecommendView alloc] init];
        recommendView2.backgroundColor = MJTRandomColor;
    //    recommendView2.bgImgView.image = [UIImage imageNamed:@""];
        [recommendView2.bgImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg"] placeholderImage:nil];
        recommendView2.titleLbl.text = @"铺贴瓷砖";
        recommendView2.detailLbl.text = @"铺墙砖·贴地砖";
        [recommendView addSubview:recommendView2];
        [recommendView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MJTGlobalViewLeftInset);
            make.right.mas_equalTo(-MJTGlobalViewLeftInset);
            make.height.mas_equalTo(98);
            make.top.mas_equalTo(recommendView1.mas_bottom).with.offset(MJTGlobalViewTopInset);
        }];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(recommendView.frame) + 20);
    
}
- (NSArray*)getData{
    return @[
        @{@"title":@"超值特价双人沙发",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f4aadd0b85f93309a4629c998773ae83&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1206%2F07%2Fc0%2F11909864_1339034191111.jpg",@"originalPrice":@"¥2990",@"currentPricel":@"¥1990",@"tag":@"皮制·鹅绒"},
      @{@"title":@"超值特价双人沙发",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744105022&di=f06819b43c8032d203642874d1893f3d&imgtype=0&src=http%3A%2F%2Fi2.sinaimg.cn%2Fent%2Fs%2Fm%2Fp%2F2009-06-25%2FU1326P28T3D2580888F326DT20090625072056.jpg",@"originalPrice":@"¥2990",@"currentPricel":@"¥1990",@"tag":@"皮制·鹅绒"},
      @{@"title":@"超值特价双人沙发",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577338893&di=189401ebacb9704d18f6ab02b7336923&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201308%2F05%2F20130805105309_5E2zE.jpeg",@"originalPrice":@"¥2990",@"currentPricel":@"¥1990",@"tag":@"皮制·鹅绒"},
      @{@"title":@"超值特价双人沙发",@"icon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576744174216&di=36ffb42bf8757df08455b34c6b7d66c5&imgtype=0&src=http%3A%2F%2Fwww.7dapei.com%2Fimages%2F201203c%2F119.3.jpg",@"originalPrice":@"¥2990",@"currentPricel":@"¥1990",@"tag":@"皮制·鹅绒"}
      ];
}
#pragma mark -- 点击事件
- (void)_addressClick{
    JFCSTableViewController *vc = [[JFCSTableViewController alloc] initWithConfiguration:[[JFCSConfiguration alloc] init] delegate:self];
    
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:[MjtLocationViewController new] animated:YES];
}

- (void)_messageClick{
    MjtMessageBaseVC *vc = [[MjtMessageBaseVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewController:(JFCSTableViewController *)viewController didSelectCity:(JFCSBaseInfoModel *)model{
 
    [self.locationBtn setTitle:model.name forState:0];
    MJTLog(model.name);
}
@end
