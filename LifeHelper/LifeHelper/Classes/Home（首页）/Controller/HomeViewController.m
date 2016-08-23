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
#import "ApsCollectionViewController.h"
#import "AppView.h"
#import "ApsViewController.h"
#import "MapViewController.h"
#import "NameCardViewController.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property(nonatomic,strong)WeatherByCityID *weather;
@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,weak) UILabel *cityLabel;
@property(nonatomic,weak) UILabel *timeLabel;
@property(nonatomic,weak) UILabel *tempratureLabel;
@property(nonatomic,weak) UILabel *windDirectionLabel;
@property(nonatomic,weak) UILabel *windStrengthLabel;
@property(nonatomic,weak) UIImageView *weatherImageView;
@property(nonatomic,weak) UILabel *weatherLabel;
@property(nonatomic,strong)NSArray *apps;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载天气数据
    [self loadData];
    [self createFrame];
    [self setData];
}
//懒加载
-(WeatherByCityID *)weather{
    if (!_weather) {
        _weather=[[WeatherByCityID alloc]init];
    }
    return _weather;
}
-(NSArray *)apps{
    if (!_apps) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"app" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        _apps=array;
        NSLog(@"count=%ld",array.count);
    }
    
    return _apps;
}
-(void)loadData{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.cityId=[ud objectForKey:@"weathercityID"];
    //NSLog(@"%@",_cityId);
    if (self.cityId==nil) {
        self.cityId=@"101010100";
    }
    
    // Do any additional setup after loading the view.
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
    NSString *httpArg = [NSString stringWithFormat:@"cityid=%@",self.cityId];

    [self request: httpUrl withHttpArg: httpArg];//加载天气信息
    
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"HttpResponseBody %@",responseString);
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    dict=dict[@"retData"];
    WeatherByCityID *weather=[WeatherByCityID WeatherWithDict:dict];
    self.weather=weather;
    //NSLog(@"qqq");
}
-(void)createFrame{

    CGFloat margin=10;
    UIView *weatherView=[[UIView alloc]init];
    weatherView.frame=CGRectMake(0, 0, self.view.frame.size.width, 150);
    
    //天气整个大button
    UIButton *weatherBtn=[[UIButton alloc]init];
    [weatherBtn setBackgroundImage:[UIImage imageNamed:@"weather_background"] forState:UIControlStateNormal];
    weatherBtn.frame=weatherView.frame;
    [weatherView addSubview:weatherBtn];
    
    //显示城市Label
    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, margin, self.view.frame.size.width*0.5, 15)];
    [weatherBtn addSubview:cityLabel];
    self.cityLabel=cityLabel;
    
    //更新时间Label
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cityLabel.frame)+margin, self.view.frame.size.width*0.5, 12)];

    timeLabel.font=[UIFont systemFontOfSize:10];
    [weatherBtn addSubview:timeLabel];
    self.timeLabel=timeLabel;
    
    //温度Label
    UILabel *tempratureLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame)+margin, self.view.frame.size.width*0.5, 16)];
    tempratureLabel.font=[UIFont systemFontOfSize:12];
    [weatherBtn addSubview:tempratureLabel];
    self.tempratureLabel=tempratureLabel;
    
    //风向风力Label
    UILabel *windDirectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tempratureLabel.frame)+margin, self.view.frame.size.width*0.5, 16)];
    windDirectionLabel.font=[UIFont systemFontOfSize:12];
    //windDirectionLabel.numberOfLines=0 ;
    [weatherBtn addSubview:windDirectionLabel];
    
    //风力Label
    UILabel *windStrengthLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(windDirectionLabel.frame)+margin, self.view.frame.size.width*0.5, 16)];
    windStrengthLabel.font=[UIFont systemFontOfSize:12];
    //windStrengthLabel.numberOfLines=0 ;
    [weatherBtn addSubview:windStrengthLabel];
    self.windDirectionLabel=windDirectionLabel;
    
    //天气图片
    UIImageView *weatherImageView=[[UIImageView alloc]init];//根据天气获取对应的天气图片
    weatherImageView.frame=CGRectMake(self.view.frame.size.width-120, 10, 100, 100);
    [weatherBtn addSubview:weatherImageView];
    self.weatherImageView=weatherImageView;
    
    //天气Label
    UILabel *weatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5, 100, self.view.frame.size.width*0.5, 15)];
   // weatherLabel.text=self.weather.weather;
    weatherLabel.textAlignment=NSTextAlignmentCenter;
    [weatherBtn addSubview:weatherLabel];
    self.weatherLabel=weatherLabel;
    
    [self.homeScrollView addSubview:weatherView];
    
    [weatherBtn addTarget:self action:@selector(jump2WeatherDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    
    //创建应用图标
    CGFloat w=80;
    CGFloat h=100;
    for (int i=0; i<self.apps.count; i++) {
        AppView *app=[AppView appView];
        NSDictionary *dict=self.apps[i];
        app.appDict=dict;
        [app setFrame:CGRectMake(margin+i%4*(margin+w), 150+i/4*(margin+h), w, h)];
        [self.homeScrollView addSubview:app];
        app.appBlock=^(){//实现appView的block，当点击button时进行跳转
        //ApsViewController *appVC=[[ApsViewController alloc]init];
            //NSLog(@"sssss");
            //NSLog(@"%@",self.navigationController);
            NSLog(@"%@",dict[@"targetVC"]);
            NSString *targetVCStr=dict[@"targetVC"];
            Class claz=NSClassFromString(targetVCStr);
            //Class claz=[targetVCStr class];
            UIViewController *vc=[[claz alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
//            if([targetVCStr isEqualToString:@"MapViewController"]){
//                MapViewController *appVC=[[MapViewController alloc]init];
//                [self.navigationController pushViewController:appVC animated:YES];
//            }
//            else if([targetVCStr isEqualToString:@"NameCardViewController"]){
//                
//                
//            }
        };
        
        
    }
    
    
    //创建流水布局
    //ApsCollectionViewController *appCV=[[ApsCollectionViewController alloc]init];
    //[appCV.view setFrame:CGRectMake(0, 150, kScreenWidth, 500)];
    //[self.navigationController pushViewController:appCV animated:YES];
    
}
-(void)setData{
    //城市Label
    self.cityLabel.text=self.weather.city;
    //NSLog(@"更新了%@",self.weather.city);
    //更新时间Label
    NSDate *nowDate=[NSDate date];//格林威治时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yy-MM-dd HH:mm";
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
    self.timeLabel.text=timeStr;
    
    //温度Label
    self.tempratureLabel.text=[NSString stringWithFormat:@"%@°C",self.weather.temp];
    
    //风向Label
    self.windDirectionLabel.text=[NSString stringWithFormat:@"%@",self.weather.WD];
    //风力Label
    self.windStrengthLabel.text=[NSString stringWithFormat:@"%@",self.self.weather.WS];
    
    //天气图片和Label
    NSString *weather=self.weather.weather;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"WeatherImage" ofType:@"plist"];
    NSDictionary *weatherImgDict=[NSDictionary dictionaryWithContentsOfFile:path];
    self.weatherImageView.image=[UIImage imageNamed:weatherImgDict[weather]];//根据天气获取对应的天气图片
    //天气Label
    self.weatherLabel.text=self.weather.weather;
}
-(void)jump2WeatherDetailView{
    WeatherDetailViewController *detailView=[[WeatherDetailViewController alloc]init];
    //为了逆传实现block
    detailView.CityBlock=^(NSString *cityID){
        self.cityId=cityID;
        //NSLog(@"%@",cityID);
        [self refreshWeater];
    };
    //NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:detailView animated:YES];
    
}

//更新城市天气
-(void)refreshWeater{
    //
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
    NSString *httpArg = [NSString stringWithFormat:@"cityid=%@",self.cityId];
    [self request: httpUrl withHttpArg: httpArg];//加载天气信息
    [self setData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


