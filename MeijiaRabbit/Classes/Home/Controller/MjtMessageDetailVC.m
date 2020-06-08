//
//  MjtMessageDetailVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/6/6.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtMessageDetailVC.h"
#import "Masonry.h"
@interface MjtMessageDetailVC ()
@property (nonatomic, weak) UILabel *timeLbl;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *addressLbl;
@property (nonatomic, weak) UILabel *categoryLbl;
@property (nonatomic, weak) UILabel *serviceNumLbl;


@end


@implementation MjtMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
    [self _loadData];
}
- (void)_setup{
    self.title = @"消息详情";
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
- (void)_loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"2";//类型1：消息列表，2：消息详情，3：删除
    param[@"msgid"] = self.message.ID;
    WeakSelf;
       [NetBaseTool postWithUrl:MJT_MESSAGE_PATH params:param decryptResponse:NO showHud:NO
        success:^(id responseDict) {
           if ([responseDict[@"status"] intValue] == 200) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [weakSelf _setupSubviews];
                   weakSelf.timeLbl.text = responseDict[@"data"][0][@"create_time"];
                   weakSelf.titleLbl.text = responseDict[@"data"][0][@"message_title"];
                   weakSelf.addressLbl.text = responseDict[@"data"][0][@"address"];
                   weakSelf.categoryLbl.text = responseDict[@"data"][0][@"service_name"];
                   weakSelf.serviceNumLbl.text = responseDict[@"data"][0][@"service_order_number"];
                   if (self.message.isread == 2) {
                       !weakSelf.readAction ? :weakSelf.readAction();
                   }
               });
           }
       } failure:^(NSError *error) {
           MJTLog(@"....");
       }];
}

- (void)_setupSubviews{
    
    //时间
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.font = [UIFont systemFontOfSize:12];
    timeLbl.textColor = MJTColorFromHexString(@"#333333");
    timeLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLbl];
    self.timeLbl = timeLbl;
    
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(10);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLbl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(150);
    }];
    
    //标题
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont boldSystemFontOfSize:14];
    titleLbl.textColor = MJTColorFromHexString(@"#333333");
    [contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(22);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = MJTGlobalBottomLineColor;
    line1.alpha = 0.7;
    [contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left);
        make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(5);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
       //服务单号
     UILabel *titleLbl0 = [[UILabel alloc] init];
     titleLbl0.text = @"服务单号：";
     titleLbl0.font = [UIFont systemFontOfSize:12];
     titleLbl0.textColor = MJTColorFromHexString(@"#333333");
     [contentView addSubview:titleLbl0];
     [titleLbl0 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(titleLbl.mas_left).with.offset(3);
         make.top.mas_equalTo(line1.mas_bottom).with.offset(8);
         make.width.mas_equalTo(65);
         make.height.mas_equalTo(25);
     }];
     
     UILabel *serviceNumLbl = [[UILabel alloc] init];
     serviceNumLbl.font = [UIFont systemFontOfSize:12];
     serviceNumLbl.textColor = MJTColorFromHexString(@"#666666");
     [contentView addSubview:serviceNumLbl];
     [serviceNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(titleLbl0.mas_right);
         make.top.mas_equalTo(titleLbl0.mas_top);
         make.right.mas_equalTo(contentView.mas_right);
         make.height.mas_equalTo(25);
     }];
     self.serviceNumLbl = serviceNumLbl;
    
    //地址
    UILabel *titleLbl1 = [[UILabel alloc] init];
    titleLbl1.text = @"地址：";
    titleLbl1.font = [UIFont systemFontOfSize:12];
    titleLbl1.textColor = MJTColorFromHexString(@"#333333");
    [contentView addSubview:titleLbl1];
    [titleLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left).with.offset(3);
        make.top.mas_equalTo(titleLbl0.mas_bottom).with.offset(8);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *addressLbl = [[UILabel alloc] init];
    addressLbl.font = [UIFont systemFontOfSize:12];
    addressLbl.textColor = MJTColorFromHexString(@"#666666");
    [contentView addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl1.mas_right);
        make.top.mas_equalTo(titleLbl1.mas_top);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(25);
    }];
    self.addressLbl = addressLbl;
    
    //服务类别
    UILabel *titleLbl2 = [[UILabel alloc] init];
    titleLbl2.text = @"服务类别：";
    titleLbl2.font = [UIFont systemFontOfSize:12];
    titleLbl2.textColor = MJTColorFromHexString(@"#333333");
    [contentView addSubview:titleLbl2];
    [titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl.mas_left).with.offset(3);
        make.top.mas_equalTo(titleLbl1.mas_bottom).with.offset(8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *categoryLbl = [[UILabel alloc] init];
    categoryLbl.font = [UIFont systemFontOfSize:12];
    categoryLbl.textColor = MJTColorFromHexString(@"#666666");
    [contentView addSubview:categoryLbl];
    [categoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLbl2.mas_right);
        make.top.mas_equalTo(titleLbl2.mas_top);
        make.right.mas_equalTo(contentView.mas_right);
        make.height.mas_equalTo(25);
    }];
    self.categoryLbl = categoryLbl;
    
}

@end
