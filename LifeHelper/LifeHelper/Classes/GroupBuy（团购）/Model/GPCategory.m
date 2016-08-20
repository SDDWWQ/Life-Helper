//
//  GPCategory.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCategory.h"
#import "GPSubCategory.h"
@implementation GPCategory
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.cat_id=dict[@"cat_id"];
        self.cat_name=dict[@"cat_name"];
        self.icon=dict[@"icon"];
        NSMutableArray *tempArray=[NSMutableArray array];
        for (NSDictionary *subDict in dict[@"subcategories"]) {
            GPSubCategory *subCat=[GPSubCategory GPSubCatWithDict:subDict];
            [tempArray addObject:subCat];
        }
        self.subcategories=tempArray;
    }
    return self;
}
+(instancetype)GPCatWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
@end
