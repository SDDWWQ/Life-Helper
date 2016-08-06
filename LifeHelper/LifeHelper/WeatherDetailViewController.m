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
@interface WeatherDetailViewController ()<WeatherCityDelegate>
//保存未来天气的视图，用于后边赋值
@property(nonatomic,strong)NSMutableArray *forecastWeatherViews;
@property(nonatomic,strong)WeatherDetailByCityID *weather;
@property(nonatomic,copy)NSString *cityId;
@end

@implementation WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //取偏好设置
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.cityId=[ud objectForKey:@"weathercityID"];
    if (self.cityId==nil) {
        self.cityId=@"101010100";
    }
    //请求天气数据
    [self getWeatherData];
   
    //storyboard加载
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WeatherDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailView"];
//    [self.navigationController pushViewController:vc animated:YES];
    //加载界面
    [self loadMainView];
    
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
//懒加载
-(NSMutableArray*)forecastWeatherViews{
    if (!_forecastWeatherViews) {
        _forecastWeatherViews=[NSMutableArray array];
    }
    return _forecastWeatherViews;
}
-(void)getWeatherData{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat: @"cityname=%%E5%%8C%%97%%E4%%BA%%AC&cityid=%@",self.cityId];
    [self request: httpUrl withHttpArg: httpArg];

}
//请求数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"HttpResponseBody %@",responseString);
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    dict=dict[@"retData"];
    WeatherDetailByCityID *weather=[WeatherDetailByCityID WeatherDetailWithDict:dict];
    self.weather=weather;
                                   //NSLog(@"%@",self.weather);
}
-(void)loadMainView{
    //添加背景图片控件
    UIImageView *backgroudImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather_background"]];
    backgroudImageView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroudImageView];
    //添加导航栏城市选择按钮
    self.navigationItem.title=@"天气预报";
    UIBarButtonItem *cityItem=[[UIBarButtonItem alloc]initWithTitle:@"城市" style:UIBarButtonItemStylePlain target:self action:@selector(jump2WeatherCity)];
    self.navigationItem.rightBarButtonItem=cityItem;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc ]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    CGFloat margin=10;
    //显示城市Label
    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 70, self.view.frame.size.width*0.5, 15)];
    cityLabel.text=self.weather.city;
    cityLabel.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:cityLabel];
    
    //今日日期Label
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cityLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    timeLabel.text=[NSString stringWithFormat:@"%@ %@",self.weather.today.date,self.weather.today.week];
    timeLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:timeLabel];
    
    //PM值Label
    UILabel *PMLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(timeLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    if ([self.weather.today.aqi isEqual:nil]) {
        PMLabel.text=[NSString stringWithFormat:@"PM:%@",self.weather.today.aqi];
    }
    PMLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:PMLabel];
    
    //温度Label
    UILabel *tempratureLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(PMLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    tempratureLabel.text=[NSString stringWithFormat:@"%@~%@",self.weather.today.hightemp,self.weather.today.lowtemp];
    tempratureLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:tempratureLabel];
    
    //风向风力Label
    UILabel *windDirectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tempratureLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    windDirectionLabel.text=[NSString stringWithFormat:@"%@",self.weather.today.fengxiang];
    windDirectionLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:windDirectionLabel];
    
    //风力Label
    UILabel *windStrengthLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(windDirectionLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    windStrengthLabel.text=[NSString stringWithFormat:@"%@",self.self.weather.today.fengli];
    windStrengthLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:windStrengthLabel];
    
    //天气图片
    NSString *weather=self.weather.today.type;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"WeatherImage" ofType:@"plist"];
    NSDictionary *weatherImgDict=[NSDictionary dictionaryWithContentsOfFile:path];
    UIImageView *weatherImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:weatherImgDict[weather]]];//根据天气获取对应的天气图片
    weatherImageView.frame=CGRectMake(self.view.frame.size.width*0.5, 70, self.view.frame.size.width*0.5, self.view.frame.size.width*0.5);
    [self.view addSubview:weatherImageView];
    
    //天气Label
    UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(windStrengthLabel.frame)+margin, self.view.frame.size.width*0.5, 10)];
    weatherLabel.text=weather;
    [self.view addSubview:weatherLabel];
    
    //生活指数
    UILabel *indexLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height*0.3+20, self.view.frame.size.width-40, 200)];
    NSString *indexs=@"";
    for (int i=0; i<self.weather.today.index.count; i++) {
        indexs=[indexs stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",[self.weather.today.index[i] name],[self.weather.today.index[i] details]]];
    }
    indexLabel.text=indexs;
    indexLabel.numberOfLines=0;
    indexLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:indexLabel];
    
    // 添加Forecast界面
    [self setupForecast];
    
    // 设置forecast天气数据
    [self setupForecastWeather];
}

-(void)back{
    //逆传
    if(self.CityBlock){
        self.CityBlock(self.cityId);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)jump2WeatherCity{
    WeatherCityTableViewController *city=[[WeatherCityTableViewController alloc]init];
    city.delegate=self;//设置自己为代理，便于逆传值
    [self.navigationController pushViewController:city animated:YES];
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
        ForecastView *forecastView=self.forecastWeatherViews[i];
        forecastView.forecast=self.weather.forecast[i];
        [self.view addSubview:forecastView];
    }
}
#pragma mark-WeatherCityTableViewController的代理方法
-(void)getCityID:(WeatherCityTableViewController *)weatherCity withCityID:(NSString *)cityID{
    self.cityId=cityID;
    //NSLog(@"%@",cityID);
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *httpArg = [NSString stringWithFormat: @"cityname=%%E5%%8C%%97%%E4%%BA%%AC&cityid=%@",cityID];
    //存偏好设置preference
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:cityID forKey:@"weathercityID"];
    [ud synchronize];//立即写入
    self.forecastWeatherViews=nil;
    [self request: httpUrl withHttpArg: httpArg];
    [self loadMainView];//[self loadView];
}
@end
