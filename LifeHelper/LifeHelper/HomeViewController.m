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
    UIButton *weatherBtn=[[UIButton alloc]init];
    [weatherBtn setBackgroundImage:[UIImage imageNamed:@"weather_background"] forState:UIControlStateNormal];
    weatherBtn.frame=weatherView.frame;
    [weatherView addSubview:weatherBtn];
    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 20)];
    NSString *city=[NSString stringWithFormat:@"%@  %@  %@", self.weather.city,self.weather.date,self.weather.temp];
    cityLabel.text=city;
    [weatherBtn addSubview:cityLabel];
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
