//
//  WeatherCity.m
//  LifeHelper
//
//  Created by shadandan on 16/7/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherCity.h"

@implementation WeatherCity
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)WeatherCityWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
