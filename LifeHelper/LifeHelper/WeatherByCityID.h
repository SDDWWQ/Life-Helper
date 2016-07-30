//
//  WeatherByCityID.h
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherByCityID : NSObject
////城市:"北京"
@property(nonatomic,copy)NSString *city;
//城市拼音:"beijing"
@property(nonatomic,copy)NSString *pinyin;
//城市编码:"101010100"
@property(nonatomic,copy)NSString *citycode;
//日期:"15-02-11"
@property(nonatomic,copy)NSString *date;
//发布时间:"11:00"
@property(nonatomic,copy)NSString *time;
//邮编:"100000"
@property(nonatomic,copy)NSString *postCode;
//经度: 116.391
@property(nonatomic,copy)NSNumber *longitude;
//维度: 39.904
@property(nonatomic,copy)NSNumber *latitude;
//海拔: "33"
@property(nonatomic,copy)NSString *altitude;
//天气情况: "晴"
@property(nonatomic,copy)NSString *weather;
//气温: "10"
@property(nonatomic,copy)NSString *temp;
//最低气温: "-4"
@property(nonatomic,copy)NSString *l_tmp;
//最高气温: "10"
@property(nonatomic,copy)NSString *h_tmp;
//风向: "无持续风向"
@property(nonatomic,copy)NSString *WD;
//风力: "微风(<10m/h)"
@property(nonatomic,copy)NSString *WS;
//日出时间:"07:12"
@property(nonatomic,copy)NSString *sunrise;
//日落时间: "17:44"
@property(nonatomic,copy)NSString *sunset;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)WeatherWithDict:(NSDictionary *)dict;
@end
