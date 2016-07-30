//
//  WeatherDetailViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/30.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherCityTableViewController.h"
@interface WeatherDetailViewController ()

@end

@implementation WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor=[UIColor redColor];
    //添加背景图片控件
    UIImageView *backgroudImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weather_background"]];
    backgroudImageView.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroudImageView];
    //添加城市Label控件
    self.navigationItem.title=@"天气";
    UIBarButtonItem *cityItem=[[UIBarButtonItem alloc]initWithTitle:@"城市" style:UIBarButtonItemStylePlain target:self action:@selector(jump2WeatherCity)];
    self.navigationItem.rightBarButtonItem=cityItem;
    
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

@end
