//
//  WeatherDetailViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherCityTableViewController.h"
#import "ForecastView.h"
#import "WeatherDetailByCityID.h"
@interface WeatherDetailViewController ()
//保存未来天气的视图，用于后边赋值
@property(nonatomic,strong)NSMutableArray *forecastWeatherViews;
@property(nonatomic,strong)WeatherDetailByCityID *weather;
@end

@implementation WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = @"cityname=%E5%8C%97%E4%BA%AC&cityid=101010100";
    [self request: httpUrl withHttpArg: httpArg];
    //添加背景图片控件
    UIImageView *backgroudImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather_background"]];
    backgroudImageView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroudImageView];
    //添加城市Label控件
    self.navigationItem.title=@"天气";
    UIBarButtonItem *cityItem=[[UIBarButtonItem alloc]initWithTitle:@"城市" style:UIBarButtonItemStylePlain target:self action:@selector(jump2WeatherCity)];
    self.navigationItem.rightBarButtonItem=cityItem;
    // 添加Forecast
    [self setupForecast];
    
    // 设置天气数据
    [self setupForecastWeather];
}
-(void)jump2WeatherCity{
    WeatherCityTableViewController *city=[[WeatherCityTableViewController alloc]init];
    [self.navigationController pushViewController:city animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   dict=dict[@"retData"];
                                   WeatherDetailByCityID *weather=[WeatherDetailByCityID WeatherDetailWithDict:dict];
                                   self.weather=weather;
                                   //NSLog(@"%@",self.weather);
}
//懒加载
-(NSMutableArray*)forecastWeatherViews{
    if (!_forecastWeatherViews) {
        _forecastWeatherViews=[NSMutableArray array];
    }
    return _forecastWeatherViews;
}
-(void)setupForecast{
    
    CGFloat forecastX=15;
    CGFloat forecastY=self.view.frame.size.height-200;
    CGFloat forecastW=70;
    CGFloat forecastH=150;
    CGFloat margin=5;
    for (int i=0; i<4; i++) {
        ForecastView *forecastView=[ForecastView forecastView];
        forecastX=10+i*(forecastW+margin);
        forecastView.frame=CGRectMake(forecastX, forecastY, forecastW, forecastH);
        [self.forecastWeatherViews addObject:forecastView];
    }
}
-(void)setupForecastWeather{
    for (int i=0; i<self.forecastWeatherViews.count; i++) {
        NSLog(@"%@",[self.weather.forecast[i] fengxiang]);
        ForecastView *forecastView=self.forecastWeatherViews[i];
        forecastView.forecast=self.weather.forecast[i];
        //forecastView.timeLabel.text=[self.weather.forecast[i] fengxiang];
        [self.view addSubview:forecastView];
    }
}

@end
