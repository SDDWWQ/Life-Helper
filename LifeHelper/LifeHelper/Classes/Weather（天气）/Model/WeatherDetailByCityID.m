//
//  WeatherDetailByCityID.m
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherDetailByCityID.h"
#import "Today.h"
#import "Forecast.h"
#import "HistoryWeather.h"
@implementation WeatherDetailByCityID
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.city=dict[@"city"];
        self.cityid=dict[@"cityid"];
        self.today=[Today TodayWeatherWithDict:dict[@"today"]];
        NSMutableArray *tempArray=[NSMutableArray array];
        for (NSDictionary *ForecastDict in dict[@"forecast"]) {
            Forecast *forecast=[Forecast ForecastWithDict:ForecastDict];
            [tempArray addObject:forecast];
        }
        self.forecast=tempArray;
        tempArray=NULL;
        for (NSDictionary *historyDict in dict[@"history"]) {
            HistoryWeather *history=[HistoryWeather HistoryWeatherWithDict:historyDict];
            [tempArray addObject:history];
        }
        self.history=tempArray;
    }
    return self;
}
+(instancetype)WeatherDetailWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
