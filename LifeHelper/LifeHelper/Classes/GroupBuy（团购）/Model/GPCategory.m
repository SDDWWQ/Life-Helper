//
//  GPCategory.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCategory.h"
@implementation GPCategory
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)GPCatWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
