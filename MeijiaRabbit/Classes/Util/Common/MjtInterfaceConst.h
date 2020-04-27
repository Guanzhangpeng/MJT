//
//  MjtInterfaceConst.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#ifndef MjtInterfaceConst_h
#define MjtInterfaceConst_h


#define MJT_ROOT_PATH @"http://192.168.10.247"
#define KURL(url) ([NSString stringWithFormat:@"%@%@",MJT_ROOT_PATH,url])

// 获取公钥
#define MJT_PUBLICKEY_PATH @"/userapi/getuserpublickey.php"

//注册
#define MJT_REGISTER_PATH @"/userapi/userregister.php"

//登录
#define MJT_LOGIN_PATH @"/userapi/login.php"

//找回密码
#define MJT_PORGETPWD_PATH @"/userapi/forgetpwd.php"

#endif /* MjtInterfaceConst_h */
