//
//  LifeIndex.h
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeIndex : NSObject
//指数指标1名称: "感冒指数"
@property(nonatomic,copy)NSString *name;
//指标编码: "gm"
@property(nonatomic,copy)NSString *code;
//等级: ""
@property(nonatomic,copy)NSString *index;
//描述:"各项气象条件适宜，发生感冒机率较低。但请避免长期处于空调房间中，以防感冒。"
@property(nonatomic,copy)NSString *details;
//其它信息: ""
@property(nonatomic,copy)NSString *otherName;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)LifeIndexWithDict:(NSDictionary *)dict;
@end

