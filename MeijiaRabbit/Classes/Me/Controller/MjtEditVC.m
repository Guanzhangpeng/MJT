//
//  MjtEditVC.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/28.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtEditVC.h"
#import "MjtBaseButton.h"
#import "UIImage+Extension.h"
@interface MjtEditVC ()
@property (nonatomic, strong) UITextField *editTxt;
@property (nonatomic, strong) MjtBaseButton *saveButton;
@end

@implementation MjtEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
}
- (void)_setupSubviews{
    [self _setupNavigation];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = MJTGlobalGrayBackgroundColor;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    UITextField *editTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    editTxt.clearButtonMode =  UITextFieldViewModeWhileEditing;
    editTxt.leftViewMode = UITextFieldViewModeAlways;
    editTxt.leftView = leftView;
    editTxt.text = [MjtUserInfo sharedUser].user_name;
    editTxt.tintColor = MJTGlobalMainColor;
    editTxt.font = [UIFont systemFontOfSize:14];
    editTxt.backgroundColor = [UIColor whiteColor];
    editTxt.textColor = MJTGlobalGrayTextColor;
    [editTxt becomeFirstResponder];
    [editTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:editTxt];
    self.editTxt = editTxt;
    
}
- (void)_setupNavigation{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_cancel_Click)];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
    MjtBaseButton *saveButton = [MjtBaseButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 50, 26);
       [saveButton setTitle:@"完成" forState:UIControlStateNormal];
       [saveButton setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#1AB84D")] forState:UIControlStateSelected];
       [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
       
       [saveButton setBackgroundImage:[UIImage imageWithColor:MJTColorFromHexString(@"#DBDBDB")] forState:UIControlStateNormal];
       [saveButton setTitleColor:MJTColorFromHexString(@"#A8A8A8") forState:UIControlStateNormal];
       saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
       saveButton.layer.cornerRadius = 6.f;
       saveButton.layer.masksToBounds = YES;
       saveButton.enabled = NO;
    [buttonView addSubview:saveButton];
    [saveButton addTarget:self action:@selector(_save_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.saveButton = saveButton;
}
- (void)_setupTextView{
    
}
#pragma mark -- 点击事件
- (void)_cancel_Click{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)_save_Click:(MjtBaseButton *)button{
    [self.view endEditing:YES];
    WeakSelf;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user_name"] = self.editTxt.text;
    [NetBaseTool postWithUrl:MJT_EditNICK_PATH params:param decryptResponse:YES showHud:YES success:^(id responseDict) {
        if ([responseDict[@"status"] intValue] == 200) {
            !weakSelf.editAction ? :weakSelf.editAction(self.editTxt.text);
            [MjtUserInfo sharedUser].user_name = self.editTxt.text;
            [MjtUserInfo saveDataToKeyChian];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.editTxt becomeFirstResponder];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)textFieldDidChange:(UITextField * )textField
{
//    if (textField == self.editTxt) {
//        if (textField.text.length > 8) {
//            textField.text = [textField.text substringToIndex:8];
//        }
//    }
    NSString *userName = [MjtUserInfo sharedUser].user_name;
    if ([textField.text isEqualToString:userName]) {
        _saveButton.selected = NO;
        _saveButton.enabled = NO;
    }else{
        _saveButton.selected = YES;
        _saveButton.enabled = YES;
    }
}
@end
