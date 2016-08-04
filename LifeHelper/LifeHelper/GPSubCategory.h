//
//  GPSubCategory.h
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSubCategory : NSObject
//二级类别id
@property(nonatomic,strong)NSNumber *subcat_id;
//二级类别名称
@property(nonatomic,copy)NSString *subcat_name;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)GPSubCatWithDict:(NSDictionary *)dict;
@end
