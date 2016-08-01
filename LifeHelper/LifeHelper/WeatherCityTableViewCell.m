//
//  WeatherCityTableViewCell.m
//  LifeHelper
//
//  Created by shadandan on 16/7/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherCityTableViewCell.h"
@interface WeatherCityTableViewCell()

@end
@implementation WeatherCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCity:(WeatherCity *)city{
    _city=city;
    if ([city.district_cn isEqualToString:city.name_cn]) {
        self.textLabel.text=[NSString stringWithFormat:@"%@省,%@市,%@",city.province_cn,city.district_cn,city.name_cn];
    }
    else{
        self.textLabel.text=[NSString stringWithFormat:@"%@省,%@市,%@区",city.province_cn,city.district_cn,city.name_cn];
    }
}
@end
