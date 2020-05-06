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
@interface MjtPublishServiceVC ()
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MjtPublishServiceVC

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
     [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
         make.bottom.mas_equalTo(addressLbl.mas_bottom);
     }];
}
#pragma mark -- 点击事件
- (void)_addressChose_Click{
    
}
- (void)_serviceChose_Click{
    
}
@end
