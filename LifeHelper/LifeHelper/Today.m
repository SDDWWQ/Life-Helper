//
//  Today.m
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "Today.h"
#import "LifeIndex.h"
@implementation Today
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.date=dict[@"date"];
        self.aqi=dict[@"aqi"];
        self.curTemp=dict[@"curTemp"];
        self.fengli=dict[@"fengli"];
        self.fengxiang=dict[@"fengxiang"];
        self.hightemp=dict[@"hightemp"];
        self.lowtemp=dict[@"lowtemp"];
        self.type=dict[@"type"];
        NSMutableArray *tempArray=[NSMutableArray array];
        for (NSDictionary *indextDict in dict[@"index"]) {
            LifeIndex *lifeIndex=[LifeIndex LifeIndexWithDict:indextDict];
            [tempArray addObject:lifeIndex];
        }
        self.index=tempArray;
    }
    return self;
}
+(instancetype)TodayWeatherWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
