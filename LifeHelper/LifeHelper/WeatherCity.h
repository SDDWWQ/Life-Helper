//
//  WeatherCity.h
//  LifeHelper
//
//  Created by shadandan on 16/7/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherCity : NSObject
@property(nonatomic,copy)NSString *province_cn; //省
@property(nonatomic,copy)NSString *district_cn; //市
@property(nonatomic,copy)NSString *name_cn;    //区、县
@property(nonatomic,copy)NSString *name_en;  //城市拼音
@property(nonatomic,copy)NSString *area_id; //城市代码
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)WeatherCityWithDict:(NSDictionary *)dict;
@end
