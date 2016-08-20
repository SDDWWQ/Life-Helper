//
//  WeatherByCityID.m
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherByCityID.h"

@implementation WeatherByCityID
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)WeatherWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
