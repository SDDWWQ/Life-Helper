//
//  GPShop.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPShop.h"
#import "Goods.h"
@implementation GPShop
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.shop_id=dict[@"shop_id"];
        self.shop_name=dict[@"shop_name"];
        self.deal_num=dict[@"deal_num"];
        self.longitude=dict[@"longitude"];
        self.latitude=dict[@"latitude"];
        self.distance=dict[@"distance"];
        self.shop_url=dict[@"shop_url"];
        self.shop_murl=dict[@"shop_murl"];
        NSMutableArray *tempArray=[NSMutableArray array];
        for (NSDictionary *dictGoods in dict[@"deals"]) {
            Goods *goods=[Goods GoodWithDict:dictGoods];
            [tempArray addObject:goods];
        }
        self.deals=tempArray;
    }
    return self;
}
+(instancetype)ShopWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
