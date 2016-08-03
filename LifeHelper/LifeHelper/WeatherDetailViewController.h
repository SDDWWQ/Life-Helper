//
//  WeatherDetailViewController.h
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailViewController : UIViewController
@property(nonatomic,copy)void (^CityBlock)(NSString *);
@end
