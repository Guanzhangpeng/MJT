//
//  MjtGoodsModel.h
//  MeijiaRabbit
//
//  Created by 管章鹏 on 2020/5/28.
//  Copyright © 2020 管章鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MjtGoodsModel : NSObject

@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *shop_price;
@property (nonatomic, strong) NSString *market_price;
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *original_img;
@property (nonatomic, strong) NSString *parent_id_path;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *url;
//"goods_name": "澜品家居简约现代北欧/样板房靠包抱枕靠垫/浅金色提花拼接腰枕 ",
//"goods_id": 300,
//"shop_price": "125.00",
//"market_price": "129.00",
//"cat_id": 11,
//"original_img": "/public/upload/goods/2019/04-16/2c21fb5aab43f774a957803ba23a284d.png",
//"parent_id_path": "0_1_11",
//"name": "床垫",
//"image": "http://m.meijiatu.cn:8080/public/upload/goods/2019/04-16/2c21fb5aab43f774a957803ba23a284d.png",
//"url": "http://ys.tpshop.com/index.php/mobile/goods/goodsInfo/id/300.html"

@end

NS_ASSUME_NONNULL_END
