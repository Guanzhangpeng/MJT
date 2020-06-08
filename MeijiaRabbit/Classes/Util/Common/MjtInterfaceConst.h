//
//  MjtInterfaceConst.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/4/24.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#ifndef MjtInterfaceConst_h
#define MjtInterfaceConst_h


#define MJT_ROOT_PATH @"http://39.102.63.135"//@"http://192.168.8.174"
#define MJT_HTMLSHOPROOT_PATH @"http://39.102.63.135:8080"

#define KURL(url) ([NSString stringWithFormat:@"%@%@",MJT_ROOT_PATH,url])
#define KShopUrl(url) ([NSString stringWithFormat:@"%@%@",MJT_HTMLSHOPROOT_PATH,url])


// 获取公钥
#define MJT_PUBLICKEY_PATH @"/userapi/getuserpublickey.php"

//注册
#define MJT_REGISTER_PATH @"/userapi/userregister.php"

//登录
#define MJT_LOGIN_PATH @"/userapi/login.php"

//找回密码
#define MJT_PORGETPWD_PATH @"/userapi/forgetpwd.php"

//修改昵称
#define MJT_EditNICK_PATH @"/userapi/editnick.php"

//修改头像
#define MJT_EditAVATAR_PATH @"/userapi/useravatar.php"

//添加 或者 修改地址
#define MJT_ADDADDRESS_PATH @"/userapi/useraddresschange.php"

//省份城市区域街道接口
#define MJT_LOCATION_PATH @"/userapi/province.php"

//收货地址列表
#define MJT_ADDRESSLIST_PATH @"/userapi/useraddresslist.php"

//设置用户默认地址/删除用户地址
#define MJT_ADDRESSOPERATION_PATH @"/userapi/useraddresshandle.php"

//服务订单列表
#define MJT_SERVICEORDER_LIST_PATH @"/userapi/userserviceorderlist.php"

//获取服务分类
#define MJT_SERVICEGET_PATH @"/userapi/getserviceclass.php"

//新增服务单
#define MJT_ADD_SERVICE_PATH @"/userapi/useraddorders.php"


// 找服务列表
#define MJT_Find_SERVICE_List_PATH @"/userapi/findserviceclass.php"

// 消息
#define MJT_MESSAGE_PATH @"/userapi/usermessage.php"

// 消息未读状态
#define MJT_MESSAGEUNREAD_PATH @"/userapi/usernewmessagecount.php"

// 装修流程
#define MJT_DECORATIONFLOW_PATH @"/case/process.html"

// 施工保障
#define MJT_WORKSURE_PATH @"/userapipage/sgensure.php"


/// 特价商品
#define MJT_HOTSHOP_PATH @"/index.php/mobile/api/getHotshop"

/// 特价列表商品
#define MJT_HOTSHOP_LIST_PATH @"/mobile/Goods/goodsList/id/1.html"

/// 校验支付结果
#define MJT_CHECKPAY_PATH @"/userapi/checkpay.php"

/// 代付款
#define MJT_WAITPAY_PATH @"/Mobile/Order/order_list/type/WAITPAY.html"

/// 代收货
#define MJT_WAITRECEIVE_PATH @"/Mobile/Order/wait_receive/type/WAITRECEIVE.html"

/// 代评价
#define MJT_WAITCOMMENT_PATH @"/Mobile/Order/comment/status/0"

/// 售后服务
#define MJT_AFTERSELL_PATH @"/Mobile/Order/return_goods_list/type/1.html"

/// 全部订单
#define MJT_ORDERLIST_PATH @"/Mobile/Order/order_list"


/// 用户城市定位信息
#define MJT_LOCATE_PATH @"/userapi/uservisitcity.php"

/// 处理服务订单
#define MJT_ORDERHANDLE_PATH @"/userapipage/handleorder.php"



#endif /* MjtInterfaceConst_h */
