//
//  HistoryWeather.m
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "HistoryWeather.h"

@implementation HistoryWeather
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)HistoryWeatherWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
