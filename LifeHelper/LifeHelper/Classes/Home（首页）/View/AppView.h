//
//  AppView.h
//  LifeHelper
//
//  Created by shadandan on 16/8/21.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppView : UIView
@property(nonatomic,strong)NSDictionary *appDict;
@property(nonatomic,copy)dispatch_block_t appBlock;
+(instancetype)appView;
@end
