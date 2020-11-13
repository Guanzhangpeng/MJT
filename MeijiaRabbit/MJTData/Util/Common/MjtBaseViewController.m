//
//  MjtBaseViewController.m
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/28.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import "MjtBaseViewController.h"

@interface MjtBaseViewController ()

@end

@implementation MjtBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setup];
}
- (void)_setup{
    self.view.backgroundColor = MJTGlobalGrayBackgroundColor;
}
@end
