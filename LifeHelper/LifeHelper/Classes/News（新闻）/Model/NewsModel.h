//
//  NewsModel.h
//  LifeHelper
//
//  Created by shadandan on 16/8/3.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property(nonatomic,copy)NSString *title; //新闻标题
@property(nonatomic,copy)NSString *url; //新闻详情页链接地址
@property(nonatomic,copy)NSString *abstract; //新闻简介
@property(nonatomic,copy)NSString *image_url; //图片链接地址
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)NewsWithDict:(NSDictionary *)dict;
@end
