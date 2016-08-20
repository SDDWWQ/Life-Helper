//
//  NewsCategory.h
//  LifeHelper
//
//  Created by shadandan on 16/8/20.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCategory : NSObject
@property(nonatomic,copy)NSString *channelId; //新闻频道id
@property(nonatomic,copy)NSString *name; //新闻频道名称
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)NewsCategoryWithDict:(NSDictionary *)dict;
@end
