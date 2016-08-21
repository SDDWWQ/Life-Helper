//
//  WeatherCityTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "WeatherCityTableViewController.h"
#import "WeatherCity.h"
#import "WeatherCityTableViewCell.h"
@interface WeatherCityTableViewController ()<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *cities;
@property (weak, nonatomic) UITextField *searchTextField;
@property(nonatomic,copy)NSString *cityId;

@end

@implementation WeatherCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UITextField *searchField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
    searchField.backgroundColor=[UIColor whiteColor];
    searchField.layer.cornerRadius=10;
//    UIImageView *searchPic=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eslf_icon_search_gray"]];
//    searchPic.frame=CGRectMake(0, 0, 35, 35);
//    [searchField.leftView addSubview:searchPic];
    self.navigationItem.titleView=searchField;
    self.searchTextField=searchField;
    //添加导航栏城市选择按钮
    UIBarButtonItem *cityItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchCity)];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_dealsmap_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem=cityItem;
    self.navigationItem.leftBarButtonItem=backItem;
    self.tableView.tableFooterView=[[UIView alloc]init];//为了去掉空的cell下边的横线，如果有footerView空的cell下边的横线就不显示，否则显示

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-懒加载初始化
-(NSMutableArray *)cities{
    if (!_cities) {
        //必须得初始化
        _cities=[NSMutableArray array];
    }
    return _cities;
}
- (void)searchCity {
    //NSLog(@"调用了");
    [self.searchTextField endEditing:YES];//收回键盘
    NSString *searchStr=self.searchTextField.text;
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
    NSString *searchStrGBK = [searchStr stringByAddingPercentEncodingWithAllowedCharacters:searchStrGBK];
    //NSLog(@"%@",searchStrGBK);
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",searchStrGBK];
    //NSString *httpArg = @"cityname=%E6%9C%9D%E9%98%B3";
    [self request: httpUrl withHttpArg: httpArg];
    [self.tableView reloadData];
     //NSLog(@"%@",self.cities);
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   //json序列化
                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSArray *array=(NSArray *)dict[@"retData"];
                                   self.cities=NULL;
                                   for (NSDictionary *cityDict in array) {
                                       WeatherCity *city=[WeatherCity WeatherCityWithDict:cityDict];
                                       [self.cities addObject:city];
                                   }
                                [self.tableView reloadData];
                               }
                           }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"加载了");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",self.cities.count);
    return self.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCity *city=self.cities[indexPath.row];
    static NSString *ID=@"WeatherCity_Cell";
    WeatherCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[WeatherCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.city=city;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cityId=[self.cities[indexPath.row] area_id];
    if ([self.delegate respondsToSelector:@selector(getCityID:withCityID:)]) {
        [self.delegate getCityID:self withCityID:self.cityId];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
