//
//  NewsModel.m
//  LifeHelper
//
//  Created by shadandan on 16/8/3.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)NewsWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
