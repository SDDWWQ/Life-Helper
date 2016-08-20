//
//  ForecastView.m
//  LifeHelper
//
//  Created by shadandan on 16/7/31.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "ForecastView.h"
#import "Forecast.h"
@implementation ForecastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setForecast:(Forecast *)forecast{
    _forecast=forecast;
    self.timeLabel.text=forecast.date;
    self.weekLabel.text=forecast.week;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"WeatherImage" ofType:@"plist"];
    NSDictionary *weatherImgDict=[NSDictionary dictionaryWithContentsOfFile:path];
    NSString *image=weatherImgDict[forecast.type];
    self.imageView.image=[UIImage imageNamed:image];
    self.typeLabel.text=forecast.type;
    self.tempLabel.text=[NSString stringWithFormat:@"%@~%@",forecast.hightemp,forecast.lowtemp];
    self.windLabel.text=[NSString stringWithFormat:@"%@",forecast.fengli];
    self.backgroundColor=[UIColor clearColor];//让View的背景透明
}
+(instancetype)forecastView{
    return [[NSBundle mainBundle]loadNibNamed:@"Forecast" owner:nil options:nil][0];
    
}

@end
