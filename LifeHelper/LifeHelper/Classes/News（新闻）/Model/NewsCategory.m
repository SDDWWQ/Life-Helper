//
//  NewsCategory.m
//  LifeHelper
//
//  Created by shadandan on 16/8/20.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NewsCategory.h"

@implementation NewsCategory
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)NewsCategoryWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
