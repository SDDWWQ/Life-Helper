//
//  HistoryWeather.h
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryWeather : NSObject
//日期:"2015-08-04"
@property(nonatomic,copy)NSString *date;
//星期: "星期一"
@property(nonatomic,copy)NSString *week;
//pm值:"92"
@property(nonatomic,copy)NSString * aqi;
//风向: "无持续风向"
@property(nonatomic,copy)NSString *fengxiang;
//风力: "微风级"
@property(nonatomic,copy)NSString *fengli;
//最高气温: "28℃"
@property(nonatomic,copy)NSString *hightemp;
//最低气温: "23℃"
@property(nonatomic,copy)NSString *lowtemp;
//天气情况: "晴"
@property(nonatomic,copy)NSString *type;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)HistoryWeatherWithDict:(NSDictionary *)dict;
@end
