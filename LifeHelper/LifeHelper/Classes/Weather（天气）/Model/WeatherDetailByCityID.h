//
//  WeatherDetailByCityID.h
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Today.h"
@interface WeatherDetailByCityID : NSObject
//城市:"北京"
@property(nonatomic,copy)NSString *city;
//城市编码: "101010100"
@property(nonatomic,copy)NSString *cityid;
//今天的具体情况
@property(nonatomic,strong)Today *today;
//未来预报列表
@property(nonatomic,strong)NSArray * forecast;
//历史天气列表
@property(nonatomic,strong)NSArray * history;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)WeatherDetailWithDict:(NSDictionary *)dict;
@end
/*
 city: "北京",  //城市名称
 cityid: "101010100", //城市编码
 today: {
 date: "2015-08-03", //今天日期
 week: "星期一",    //今日星期
 curTemp: "28℃",    //当前温度
 aqi: "92",        //pm值
 fengxiang: "无持续风向", //风向
 fengli: "微风级",     //风力
 hightemp: "30℃",   //最高温度
 lowtemp: "23℃",    //最低温度
 type: "阵雨",      //天气状态
 index: [  //指标列表
 {
 name: "感冒指数", //指数指标1名称
 code: "gm",     //指标编码
 index: "",      //等级
 details: "各项气象条件适宜，发生感冒机率较低。但请避免长期处于空调房间中，以防感冒。",//描述
 otherName: "" //其它信息
 },
 {
 code: "fs",
 details: "属中等强度紫外辐射天气，外出时应注意防护，建议涂擦SPF指数高于15，PA+的防晒护肤品。",
 index: "中等",
 name: "防晒指数",
 otherName: ""
 },
 {
 code: "ct",
 details: "天气炎热，建议着短衫、短裙、短裤、薄型T恤衫等清凉夏季服装。",
 index: "炎热",
 name: "穿衣指数",
 otherName: ""
 },
 {
 code: "yd",
 details: "有降水，推荐您在室内进行低强度运动；若坚持户外运动，须注意选择避雨防滑并携带雨具。",
 index: "较不宜",
 name: "运动指数",
 otherName: ""
 },
 {
 code: "xc",
 details: "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。",
 index: "不宜",
 name: "洗车指数",
 otherName: ""
 },
 {
 code: "ls",
 details: "有降水，不适宜晾晒。若需要晾晒，请在室内准备出充足的空间。",
 index: "不宜",
 name: "晾晒指数",
 otherName: ""
 }
 ]
 },
 forecast: [ //回来预报列表
 {
 date: "2015-08-04",
 week: "星期二",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "32℃",
 lowtemp: "23℃",
 type: "多云"
 },
 {
 date: "2015-08-05",
 week: "星期三",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "30℃",
 lowtemp: "23℃",
 type: "多云"
 },
 {
 date: "2015-08-06",
 week: "星期四",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "29℃",
 lowtemp: "24℃",
 type: "雷阵雨"
 },
 {
 date: "2015-08-07",
 week: "星期五",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "30℃",
 lowtemp: "24℃",
 type: "多云"
 }
 ],
 history: [ //历史天气列表
 
 {
 date: "2015-07-31",
 week: "星期五",
 aqi: "52",
 fengxiang: "无持续风向",
 fengli: "微风级",
 hightemp: "高温 29℃",
 lowtemp: "低温 22℃",
 type: "多云"
 },
 {
 date: "2015-08-01",
 week: "星期六",
 aqi: null,
 fengxiang: "南风",
 fengli: "微风级",
 hightemp: "高温 35℃",
 lowtemp: "低温 26℃",
 type: "多云"
 }
 ]
 }
 */
