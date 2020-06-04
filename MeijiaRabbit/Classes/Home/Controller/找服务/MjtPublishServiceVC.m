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
#import "BRPickerView.h"
#import "MjtAddressListVC.h"
#import "YWAddressInfoModel.h"
#import "MjtFindServiceModel.h"
#import "MjtServiceAlertView.h"
#define HWStatusPhotoWH  (([UIScreen mainScreen].bounds.size.width - HWStatusPhotoMargin * 4) / 3)
#define HWStatusPhotoMargin (15)
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
@interface MjtPublishServiceVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *serviceLbl;
@property (nonatomic, strong) UITextView *descTxt;//需求描述
@property (nonatomic, strong) NSMutableArray *serviceArray;
@property (nonatomic, strong) YWAddressInfoModel *addressModel;
@property (nonatomic, strong) NSString *service_id;// 服务分类ID;
@property (nonatomic, strong) NSString *service_sub_id;// 服务分类子ID;
@property (nonatomic, strong) NSArray<UIImage *> *photos;

@end

@implementation MjtPublishServiceVC
static NSString *CellID = @"MjtServiceRecommendCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _setupSubviews];
    [self _loadData];
}
-(void)setServiceModel:(MjtFindServiceModel *)serviceModel{
    _serviceModel = serviceModel;
    self.service_id = serviceModel.pid;
    self.service_sub_id = serviceModel.ID;
}
- (void)_loadData{
    [NetBaseTool postWithUrl:MJT_SERVICEGET_PATH params:nil decryptResponse:NO showHud:NO success:^(id responseDict) {
      NSMutableArray *dataSource = [NSMutableArray array];
        NSArray *results = responseDict[@"data"];
        for (NSDictionary *dict in results) {
            BRProvinceModel *categoryModel = [[BRProvinceModel alloc] init];
            categoryModel.name = dict[@"category_name"];
            categoryModel.code = dict[@"id"];
            NSArray *children = dict[@"children"];
            NSMutableArray *localList = [NSMutableArray array];
            for (NSDictionary *item in children) {
                BRCityModel *model = [[BRCityModel alloc] init];
                model.name = item[@"name"];
                model.code = item[@"childrenid"];
                [localList addObject:model];
            }
            categoryModel.citylist = localList;
            [dataSource addObject:categoryModel];
        }
        MJTLog(@"%@",dataSource);
        self.serviceArray = dataSource;
        
    } failure:^(NSError *error) {
        
    }];
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
    [self _atttributeLabel:titleLbl1];
    MjtBaseButton *choseAddressBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [choseAddressBtn setImage:[UIImage imageNamed:@"button_plus"] forState:0];
    [choseAddressBtn addTarget:self action:@selector(_addressChose_Click) forControlEvents:UIControlEventTouchUpInside];
    choseAddressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.scrollView addSubview:choseAddressBtn];
    [choseAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).with.offset(-margin);
        make.centerY.mas_equalTo(titleLbl1.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);

    }];
     
    UILabel *addressLbl = [[UILabel alloc] init];
    addressLbl.numberOfLines = 0;
    addressLbl.textColor = MJTColorFromHexString(@"#999999");
    addressLbl.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl1.mas_bottom).with.offset(8);
        make.left.mas_equalTo(titleLbl1.mas_left).with.offset(8);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
    }];
    self.addressLbl = addressLbl;
    
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
    [self _atttributeLabel:titleLbl2];
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
    serviceLbl.text = self.serviceModel.name;
    serviceLbl.numberOfLines = 0;
    serviceLbl.textColor = MJTColorFromHexString(@"#999999");
    serviceLbl.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:serviceLbl];
    [serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl2.mas_bottom).with.offset(8);
        make.left.mas_equalTo(titleLbl1.mas_left).with.offset(8);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
    }];
    self.serviceLbl = serviceLbl;
    
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
    [self _atttributeLabel:titleLbl3];
    UITextView *descTxt = [[UITextView alloc] init];
    descTxt.font = [UIFont systemFontOfSize:13];
    descTxt.backgroundColor = [UIColor whiteColor];
    descTxt.layer.cornerRadius = 8;
    descTxt.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
    [scrollView addSubview:descTxt];
    [descTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl1.mas_left);
        make.right.mas_equalTo(choseAddressBtn.mas_right).with.offset(-margin);
        make.height.mas_equalTo(120);
        make.top.mas_equalTo(titleLbl3.mas_bottom).with.offset(margin);
    }];
    self.descTxt = descTxt;
    
    //上传现场改造图片
    UILabel *titleLbl4 = [[UILabel alloc] init];
       titleLbl4.text = @"上传改造现场图片";
       titleLbl4.font = [UIFont systemFontOfSize:14];
       [self.scrollView addSubview:titleLbl4];
       [titleLbl4 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(titleLbl1.mas_left);
           make.width.mas_equalTo(140);
           make.height.mas_equalTo(21);
           make.top.mas_equalTo(descTxt.mas_bottom).with.offset(margin*3);
       }];
    
    ImagePickerView *imgPickerVC = [[ ImagePickerView alloc] init];
    //图片选择器 最大数量
      NSInteger maxImagesCount = 9;
    WeakSelf;
    __weak typeof(imgPickerVC) weakPickerVC = imgPickerVC;
    imgPickerVC.didFinishPickingPhotos = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.photos = photos;
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
    
    //提交需求
    MjtBaseButton *submitBtn = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交需求" forState:0];
    [submitBtn setTitleColor:[UIColor blackColor] forState:0];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.backgroundColor = MJTGlobalMainColor;
    submitBtn.layer.cornerRadius = 8;
    [submitBtn addTarget:self action:@selector(_submitButton_Click) forControlEvents:UIControlEventTouchUpInside
     ];
    [self.scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(25);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(imgPickerVC.view.mas_bottom).with.offset(85);
        
    }];
     [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
         make.bottom.mas_equalTo(submitBtn.mas_bottom).with.offset(50);
     }];
}
//处理字符,让第一个文字红色显示
- (void)_atttributeLabel:(UILabel *)label{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    label.attributedText = attrStr;
}

#pragma mark -- 点击事件
- (void)_addressChose_Click{
    WeakSelf;
    MjtAddressListVC *addressList = [[MjtAddressListVC alloc] init];
    addressList.choseAction = ^(YWAddressInfoModel * _Nonnull addressModel) {
        weakSelf.addressLbl.text = addressModel.detail_address;
        weakSelf.addressModel = addressModel;
    };
    [self.navigationController pushViewController:addressList animated:YES];
}
- (void)_serviceChose_Click{
    /// 地址选择器
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc] init];
    addressPickerView.pickerMode = BRAddressPickerModeCity;
    addressPickerView.dataSourceArr = self.serviceArray;
    addressPickerView.isAutoSelect = YES;
    WeakSelf;
    addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name]);
        weakSelf.serviceLbl.text = [NSString stringWithFormat:@"%@ %@", province.name, city.name];
        weakSelf.service_id = province.code;
        weakSelf.service_sub_id = city.code;
    };

    [addressPickerView show];
}
- (void)_submitButton_Click{

    
    if ([self.addressLbl.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请选择您的服务地址" view:self.view];
        return;
    }
    
    if ([self.serviceLbl.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请选择您的服务分类" view:self.view];
        return;
    }
    
    if ([self.descTxt.text isEqualToString:@""] ) {
        [MBProgressHUD wj_showPlainText:@"请输入您的详细具体需求" view:self.view];
        return;
    }
    WeakSelf;
    MjtServiceAlertView *aletView = [[MjtServiceAlertView alloc] init];
    aletView.dismissAction = ^{
        [weakSelf submitRequest];
    };
    [aletView show];
    
}
- (void)submitRequest{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = [MjtUserInfo sharedUser].ID;
    param[@"addressid"] = self.addressModel.ID;
    param[@"service_id"] = self.service_id;
    param[@"service_sub_id"] = self.service_sub_id;
    param[@"description"] = self.descTxt.text;
    
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    formData[@"file"] = self.photos;
    [NetBaseTool postWithURL:MJT_ADD_SERVICE_PATH params:param formDataArray:formData success:^(id responseObjc) {
        if ([responseObjc[@"status"] intValue] == 200) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
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
#pragma mark -- 懒加载
-(NSMutableArray *)serviceArray{
    if (!_serviceArray) {
        _serviceArray = [NSMutableArray array];
    }
    return _serviceArray;
}
@end
