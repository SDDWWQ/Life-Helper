//
//  GPFooterView.h
//  LifeHelper
//
//  Created by shadandan on 16/8/5.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPShop.h"
@class GPFooterView;
@protocol GPFooterViewDelegate<NSObject>
@optional
-(void)footerViewClick:(GPFooterView*)footerView;
@end
@interface GPFooterView : UIView
@property(nonatomic,strong)GPShop *shop;
+(instancetype)footerView;
@property(nonatomic,weak)id<GPFooterViewDelegate> delegate;
@end
