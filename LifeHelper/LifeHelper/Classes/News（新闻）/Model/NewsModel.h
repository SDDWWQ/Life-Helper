//
//  NewsModel.h
//  LifeHelper
//
//  Created by shadandan on 16/8/3.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property(nonatomic,strong)NSArray *allList; //
@property(nonatomic,copy)NSString *pubDate;//发布时间
@property(nonatomic,copy)NSString *title; //新闻标题
@property(nonatomic,copy)NSString *channelName;
@property(nonatomic,strong)NSArray *imageurls; //图片链接地址

@property(nonatomic,copy)NSString *desc; //新闻描述
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *source;//新闻来源

@property(nonatomic,strong)NSNumber *sentiment_display;//
@property(nonatomic,strong)NSDictionary *sentiment_tag;
@property(nonatomic,copy)NSString *channelId;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,copy)NSString *link; //新闻详情页链接地址






-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)NewsWithDict:(NSDictionary *)dict;
@end
