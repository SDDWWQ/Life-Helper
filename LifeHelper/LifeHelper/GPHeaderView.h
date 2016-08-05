//
//  GPHeaderView.h
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPShop.h"
@protocol GPHeaderViewDelegate<NSObject>

@end
@interface GPHeaderView : UIView
@property(nonatomic,strong)GPShop *shop;
+(instancetype)headerView;
@property(nonatomic,weak)id<GPHeaderViewDelegate> delegate;
@end
