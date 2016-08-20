//
//  GPCategory.h
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCategory : NSObject
//一级类别id
@property(nonatomic,strong)NSNumber *cat_id;
//一级类别名称
@property(nonatomic,copy)NSString *cat_name;
//图标
@property(nonatomic,copy)NSString *icon;
//子类别
@property(nonatomic,strong)NSArray *subcategories;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)GPCatWithDict:(NSDictionary *)dict;
@end
