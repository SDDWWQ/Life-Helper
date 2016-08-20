//
//  Goods.h
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject
//团单id
@property(nonatomic,strong)NSNumber *deal_id;
//大图链接
@property(nonatomic,copy)NSString *image;
//小图链接
@property(nonatomic,copy)NSString *tiny_image;
//商户标题
@property(nonatomic,copy)NSString *title;
//商户小标题
@property(nonatomic,copy)NSString *min_title;
//商户描述
@property(nonatomic,copy)NSString *Description;
//市场价格，单位是分
@property(nonatomic,strong)NSNumber *market_price;
//售卖价格，单位是分
@property(nonatomic,strong)NSNumber *current_price;
//活动价格，单位是分
@property(nonatomic,strong)NSNumber *promotion_price;
//已售团单数量
@property(nonatomic,strong)NSNumber *sale_num;
//用户评分
@property(nonatomic,strong)NSNumber *score;
//用户评论个数
@property(nonatomic,strong)NSNumber *comment_num;
//Pc团单详情页
@property(nonatomic,copy)NSString *deal_url;
//Wap团详情页
@property(nonatomic,copy)NSString *deal_murl;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)GoodWithDict:(NSDictionary *)dict;
@end
