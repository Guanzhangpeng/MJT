//
//  YWAddressViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "YWAddressViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import "YWTool.h"

#import "YWAddressTableViewCell1.h"
#import "YWAddressTableViewCell2.h"
#import "YWAddressTableViewCell3.h"
#import "ZHFAddTitleAddressView.h"
#define CELL_IDENTIFIER1     @"YWAddressTableViewCell1"
#define CELL_IDENTIFIER2     @"YWAddressTableViewCell2"
#define CELL_IDENTIFIER3     @"YWAddressTableViewCell3"

@interface YWAddressViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,UIGestureRecognizerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate,ZHFAddTitleAddressViewDelegate>

@property (nonatomic, strong) UITableView         * tableView;
@property (nonatomic, strong) NSArray             * dataSource;
@property (nonatomic, strong) UITextView          * detailTextViw;

//@property (nonatomic,strong) YWChooseAddressView  * chooseAddressView;
@property (nonatomic, strong) UIView               * coverView;

@property (nonatomic, strong) UILabel             * promptLable;

@property (nonatomic, strong)ZHFAddTitleAddressView * addTitleAddressView;


- (void)initUserInterface;  /**< 初始化用户界面 */
- (void)initUserDataSource;  /**< 初始化数据源 */

@end

@implementation YWAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserDataSource];
    [self initUserInterface];
    
}
-(BOOL)navigationShouldPopOnBackButton{
    return YES;
}
-(void)setUI{
    self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = ScreenWidth;
    self.addTitleAddressView.titleScrollViewH = 37;
    if (self.isEditing) {
        self.addTitleAddressView.isChangeAddress = true;
        self.addTitleAddressView.titleIDMarr = self.titleIDMarr;
    }
    else{
        self.addTitleAddressView.isChangeAddress = false;
    }
   
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
}
- (void)initUserInterface {
    self.title = @"添加新地址";
    if (self.isEditing) {
        self.title = @"编辑地址";
    } else {
        _model = [[YWAddressInfoModel alloc] init];
    }
    
    //监听所有的textView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewPlaceholder) name:UITextViewTextDidChangeNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(navRightItem)];
    
    [self.view addSubview:self.tableView];
    
    [self setUI];
}

- (void)initUserDataSource {
    
    _dataSource = @[@[@"收货人", @"联系电话", @"所在地区"],
                    @[@"设为默认"]];
}

#pragma mark -- action
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    _model.address = titleAddress;
    [self.tableView reloadData];
    NSArray *areaIDS = [titleID componentsSeparatedByString:@"="];
    if (areaIDS.count == 4) {
        _model.province_code = areaIDS[0];
        _model.city_code = areaIDS[1];
        _model.area_code = areaIDS[2];
        _model.street_code = areaIDS[3];
    }
    NSLog( @"%@", [NSString stringWithFormat:@"打印的对应省市县的id=%@",titleID]);
}
//*** 导航栏右上角 - 保存按钮 ***
- (void)navRightItem {
    [self.view endEditing:YES];
    YWAddressTableViewCell1 *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    YWAddressTableViewCell1 *phoneCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    YWAddressTableViewCell3 *defaultCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    _model.name = nameCell.textField.text;
    _model.phone = phoneCell.textField.text;
    _model.house_number = _detailTextViw.text;
    _model.default_address = defaultCell.rightSwitch.isOn ? @"1" : @"2";

    if (_model.name.length == 0) {
        [MBProgressHUD wj_showPlainText:@"请填写收货人姓名！" view:self.view];
        return;
    } else if (_model.phone.length == 0) {
        [MBProgressHUD wj_showPlainText:@"请填写收货人电话！" view:self.view];
        return;
    } else if (_model.phone.length != 11) {
        [MBProgressHUD wj_showPlainText:@"请输入合法的手机号" view:self.view];
        return;
    } else if ([_model.address isEqualToString:@"请选择"]) {
         [MBProgressHUD wj_showPlainText:@"请选择所在地区" view:self.view];
        return;
    } else if (_model.house_number.length == 0 || _model.house_number.length < 5) {
         [MBProgressHUD wj_showPlainText:@"请填写详细地址，不少与5字" view:self.view];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"1";//(1：新增，2：编辑)
    param[@"userid"] = [MjtUserInfo sharedUser].ID;
    param[@"name"] = _model.name;
    param[@"phone"] = _model.phone;
    param[@"province_code"] = _model.province_code;//省份code
    param[@"city_code"] = _model.city_code;//CITY code
    param[@"area_code"] = _model.area_code;//地区code
    param[@"street_code"] = _model.street_code;//街道code
    param[@"house_number"] = _model.house_number;//门牌号
    param[@"detail_address"] = [NSString stringWithFormat:@"%@%@",_model.address,_model.house_number];//详细地址
    param[@"default_address"] = _model.default_address;//是否设默认地址（1：是，2：否）
    
    if(self.isEditing){
        param[@"type"] = @"2";
        param[@"id"] = _model.ID;
        
    }
    WeakSelf;
    [NetBaseTool postWithUrl:MJT_ADDADDRESS_PATH params:param decryptResponse:YES showHud:YES success:^(id responseDict) {
        if([responseDict[@"status"] intValue] == 200){
                // 回调所填写的地址信息（姓名、电话、地址等等）
            if (weakSelf.addressBlock) {
                weakSelf.addressBlock(weakSelf.model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];

    [self.navigationController popViewControllerAnimated:YES];
    
}

// textView 水印字体
- (void)textViewPlaceholder {
    self.promptLable.hidden = self.detailTextViw.text.length > 0 ? 1 : 0;
}

#pragma mark *** 弹出选择地区视图 ***
- (void)chooseAddress {
    [self.addTitleAddressView addAnimate];
}

#pragma mark *** 从通讯录选择联系人 电话 & 姓名 ***
//用户点击 加号按钮 - 选择联系人
- (void)selectContactAction {
    // 弹出联系人列表 - 此方法只使用于 iOS 9.0以后
    CNContactPickerViewController * pickerVC = [[CNContactPickerViewController alloc]init];
    pickerVC.navigationItem.title = @"选择联系人";
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}


#pragma mark - CNContactPickerDelegate
// 这个方法在用户选择一个联系人后调用
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1.获取姓名
    NSString *firstname = contact.givenName;
    NSString *lastname = contact.familyName;
    NSLog(@"%@%@", lastname, firstname);
    
    //通过姓名寻找联系人
    NSMutableString *fullName = [[NSMutableString alloc] init];
    if ( lastname != nil || lastname.length > 0 ) {
        [fullName appendString:lastname];
    }
    if ( firstname != nil || firstname.length > 0 ) {
        [fullName appendString:firstname];
    }
    
    // 2.获取电话号码
    NSArray *phones = contact.phoneNumbers;
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    // 3.遍历电话号码
    for (CNLabeledValue *labelValue in phones) {
        CNPhoneNumber *phoneNumber = labelValue.value;
        //把 -、+86、空格 这些过滤掉
        NSString *phoneStr = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [phoneNumbers addObject:phoneStr];
    }
    
    NSLog(@"选择的姓名：%@， 电话号码：%@", fullName, phoneNumbers.firstObject);
    _model.name = fullName;
    // 这里直接取第一个电话号码，如果有多个请自行添加选择器
    _model.phone = phoneNumbers.firstObject;
    [_tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark *** UITableViewDataSource & UITableViewDelegate ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if ([_model.default_address isEqualToString:@"1"]) {
//        // 如果该地址已经是默认地址，则无需再显示 "设为默认" 这个按钮，即隐藏
//        return 1;
//    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            YWAddressTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER1 forIndexPath:indexPath];
            cell.rightBtn.hidden = YES;
            cell.placehodlerStr = @"填写收货人姓名";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];
            if (_model.name.length > 0) {
                cell.textFieldStr = _model.name;
            }
            if (indexPath.row == 1) {
                cell.rightBtn.hidden = NO;
                cell.placehodlerStr = @"填写收货人电话";
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                if (_model.phone.length > 0) {
                    cell.textFieldStr = _model.phone;
                }
                cell.contactBlock = ^{
                    [weakSelf selectContactAction];
                };
            }
            return cell;
        } else {
            YWAddressTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER2 forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];
            cell.rightStr = _model.address;
            if (![_model.address isEqualToString:@""] && ![_model.address isEqualToString:@"请选择"]) {
                cell.rightLabel.textColor = [UIColor blackColor];
            } else {
                cell.rightLabel.textColor = [UIColor lightGrayColor];
            }
            return cell;
        }
    } else {
        YWAddressTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER3 forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftStr = _dataSource[indexPath.section][indexPath.row];

        if ([_model.default_address isEqualToString:@"1"]) {
            [cell.rightSwitch setOn:YES];
        }
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:self.detailTextViw];
        return footerView;
    } else {
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 75;
    }else{
        return 65;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消cell选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self.view endEditing:YES];
        // 选择地区
        [self chooseAddress];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER1 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER1];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER2 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER2];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER3 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER3];
    }
    return _tableView;
}

- (UITextView *)detailTextViw {
    if (!_detailTextViw) {
        _detailTextViw = [[UITextView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 80)];
        _detailTextViw.textContainerInset = UIEdgeInsetsMake(8, 15, 8, 15);
        _detailTextViw.font = [UIFont systemFontOfSize:14];
        [_detailTextViw addSubview:self.promptLable];
        
        if (_model.house_number.length > 0) {
            _detailTextViw.text = _model.house_number;
            self.promptLable.hidden = YES;
        }
    }
    return _detailTextViw;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(20 , 8, ScreenWidth, 24)];
        _promptLable.text = @"请填写详细地址（尽量精确到单元楼或门牌号)";
        _promptLable.numberOfLines = 0;
        _promptLable.textColor = MJTColorA(200, 200, 200, 1);
        _promptLable.textAlignment = NSTextAlignmentJustified;
        [_promptLable setFont:[UIFont systemFontOfSize:14]];
    }
    return _promptLable;
}
@end

