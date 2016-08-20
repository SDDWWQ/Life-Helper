//
//  WeatherXib.h
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherXib : UIView
@property(nonatomic,copy)NSString *city;
+(instancetype)weatherXibView;
@property (weak, nonatomic) IBOutlet UIButton *weatherBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end
