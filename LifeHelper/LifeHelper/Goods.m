//
//  Goods.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "Goods.h"

@implementation Goods

//解决key-description和系统中重名问题，模型中改个名字，kvc和键值对匹配时再替换一下名字
+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"Description":@"description"};
    
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)GoodWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
