//
//  GPCategoryView.h
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPCategoryView;
@protocol GPCategoryClickDelegate<NSObject>
@optional
-(void)jumpToGPTableView:(GPCategoryView *)GPCat withCatId:(NSNumber *)cat_id;
@end

@interface GPCategoryView : UIView
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *picture;
//一级类别id
@property(nonatomic,strong)NSNumber *cat_id;
@property(nonatomic,weak)id<GPCategoryClickDelegate> delegate;
+(instancetype)categoryView;
@end
