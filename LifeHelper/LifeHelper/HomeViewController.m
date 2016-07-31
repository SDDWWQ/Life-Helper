//
//  HomeViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "HomeViewController.h"
//#import "WeatherXib.h"
#import "WeatherDetailViewController.h"
#import "WeatherByCityID.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property(nonatomic,strong)WeatherByCityID *weather;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
    NSString *httpArg = @"cityid=101010100";
    [self request: httpUrl withHttpArg: httpArg];//加载天气信息
    UIView *weatherView=[[UIView alloc]init];
    weatherView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.25);
    //天气整个大button
    UIButton *weatherBtn=[[UIButton alloc]init];
    [weatherBtn setBackgroundImage:[UIImage imageNamed:@"weather_background"] forState:UIControlStateNormal];
    weatherBtn.frame=weatherView.frame;
    [weatherView addSubview:weatherBtn];
    //显示城市Label
    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width*0.5, 15)];
    
    NSString *city=[NSString stringWithFormat:@"%@  %@  %@", self.weather.city,self.weather.date,self.weather.temp];
    cityLabel.text=self.weather.city;
    [weatherBtn addSubview:cityLabel];
    
    //更新时间Label
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, self.view.frame.size.width*0.5, 10)];
    NSDate *nowDate=[NSDate date];//格林威治时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yy-MM-dd HH:mm";
    //NSString *nowDateStr=[dateFormatter stringFromDate:nowDate];//格式化之后就是本地时间
    //NSLog(@"%@",nowDateStr);
    NSString *weatherDateStr=[NSString stringWithFormat:@"%@ %@",self.weather.date,self.weather.time];
    NSDate *weatherDate=[dateFormatter dateFromString:weatherDateStr];
    //NSLog(@"%@",weatherDate);
    //创建一个日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //比较时间
    int unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    NSDateComponents *compare=[calendar components:unit fromDate:weatherDate toDate:nowDate options:0];
    NSString *timeStr;
    if (compare.year!=0) {
        timeStr=[NSString stringWithFormat:@"%ld年前更新",compare.year];
    }else if (compare.month){
        timeStr=[NSString stringWithFormat:@"%ld个月前更新",compare.month];
    }else if(compare.hour!=0) {
        timeStr=[NSString stringWithFormat:@"%ld小时前更新",compare.hour];
    }else if(compare.minute){
        timeStr=[NSString stringWithFormat:@"%ld分钟前更新",compare.minute];
    }
    else if(compare.minute==0){
        timeStr=@"刚刚更新";
    }
    timeLabel.text=timeStr;
    timeLabel.font=[UIFont systemFontOfSize:10];
    [weatherBtn addSubview:timeLabel];
    
    //温度Label
     UILabel *tempratureLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.view.frame.size.width*0.5, 15)];
    tempratureLabel.text=[NSString stringWithFormat:@"%@°C",self.weather.temp];
    [weatherBtn addSubview:tempratureLabel];
    
    //风向风力Label
    UILabel *windDirectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width*0.5, 15)];
    windDirectionLabel.text=[NSString stringWithFormat:@"%@",self.weather.WD];
    //windDirectionLabel.numberOfLines=0 ;
    [weatherBtn addSubview:windDirectionLabel];
    //风力Label
    UILabel *windStrengthLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width*0.5, 15)];
    windStrengthLabel.text=[NSString stringWithFormat:@"%@",self.self.weather.WS];
    //windStrengthLabel.numberOfLines=0 ;
    [weatherBtn addSubview:windStrengthLabel];
    
    //天气图片和Label
    NSString *weather=self.weather.weather;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"WeatherImage" ofType:@"plist"];
    NSDictionary *weatherImgDict=[NSDictionary dictionaryWithContentsOfFile:path];
    UIImageView *weatherImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:weatherImgDict[weather]]];//根据天气获取对应的天气图片
    weatherImageView.frame=CGRectMake(self.view.frame.size.width*0.5, 10, self.view.frame.size.width*0.5, self.view.frame.size.height*0.2);
    [weatherBtn addSubview:weatherImageView];
    
    UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.7, self.view.frame.size.width*0.2+10+5, self.view.frame.size.width*0.5-10, 15)];
    weatherLabel.text=self.weather.weather;
    [weatherBtn addSubview:weatherLabel];


    [self.homeScrollView addSubview:weatherView];
    
    
    
    [weatherBtn addTarget:self action:@selector(jump2WeatherDetailView) forControlEvents:UIControlEventTouchUpInside];
    


    
}
//-(void)viewWillAppear:(BOOL)animated{
//    WeatherXib *weatherView;
//    weatherView.city=[NSString stringWithFormat:@"%@  %@  %@", self.weather.city,self.weather.date,self.weather.temp];
//    weatherView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.25);
//    [self.homeScrollView addSubview:weatherView];
//    weatherView=[WeatherXib weatherXibView];
//    [weatherView.weatherBtn addTarget:self action:@selector(jump2WeatherDetailView) forControlEvents:UIControlEventTouchUpInside];
//}
//懒加载
-(WeatherByCityID *)weather{
    if (!_weather) {
        _weather=[[WeatherByCityID alloc]init];
    }
    return _weather;
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    [NSURLConnection sendAsynchronousRequest: request
//                                       queue: [NSOperationQueue mainQueue]
//                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
//                               if (error) {
//                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
//                               } else {
//                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   dict=dict[@"retData"];
                                   WeatherByCityID *weather=[WeatherByCityID WeatherWithDict:dict];
                                   self.weather=weather;
                                   NSLog(@"qqq");
                                   
                                   
//                               }
//                           }];
}
-(void)jump2WeatherDetailView{
    WeatherDetailViewController *detailView=[[WeatherDetailViewController alloc]init];
    [self.navigationController pushViewController:detailView animated:YES];
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

@end
