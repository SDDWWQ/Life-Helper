//
//  GPShop.h
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPShop : NSObject
//店铺id
@property(nonatomic,strong)NSNumber *shop_id;
//店铺名称
@property(nonatomic,copy)NSString *shop_name;
//经度
@property(nonatomic,strong)NSNumber *longitude;
//纬度
@property(nonatomic,strong)NSNumber *latitude;

@property(nonatomic,strong)NSNumber *distance;
//团单数量
@property(nonatomic,strong)NSNumber *deal_num;
//店铺网址
@property(nonatomic,copy)NSString *shop_url;
//店铺手机端网址
@property(nonatomic,copy)NSString *shop_murl;
//平均价格
@property(nonatomic,copy)NSString *per_price;
//平均得分
@property(nonatomic,copy)NSString *average_score;
//地址
@property(nonatomic,copy)NSString *address;
//小图链接
@property(nonatomic,copy)NSString *tiny_image;
//团单
@property(nonatomic,strong)NSArray *deals;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)ShopWithDict:(NSDictionary *)dict;
@end
