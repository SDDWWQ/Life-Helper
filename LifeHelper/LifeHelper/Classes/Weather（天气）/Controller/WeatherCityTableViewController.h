//
//  WeatherCityTableViewController.h
//  LifeHelper
//
//  Created by shadandan on 16/7/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherCityTableViewController;
//创建代理协议，实现逆传
@protocol WeatherCityDelegate<NSObject>
@optional
-(void)getCityID:(WeatherCityTableViewController *)weatherCity withCityID:(NSString *)cityID;
@end
@interface WeatherCityTableViewController : UITableViewController
@property(nonatomic,weak)id<WeatherCityDelegate> delegate;
@end
