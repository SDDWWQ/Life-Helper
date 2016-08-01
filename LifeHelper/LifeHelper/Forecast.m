//
//  Forecast.m
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)ForecastWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
