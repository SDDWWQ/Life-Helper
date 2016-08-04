//
//  GPSubCategory.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPSubCategory.h"

@implementation GPSubCategory
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)GPSubCatWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
