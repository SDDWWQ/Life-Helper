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
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation WeatherCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
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
- (IBAction)searchClick:(id)sender {
    NSString *searchStr=self.searchTextField.text;
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
    NSString *searchStrGBK = [searchStr stringByAddingPercentEncodingWithAllowedCharacters:searchStrGBK];
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",searchStrGBK];
    //NSString *httpArg = @"cityname=%E6%9C%9D%E9%98%B3";
    [self request: httpUrl withHttpArg: httpArg];
    [self.tableView reloadData];
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
                                   //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                                   //json序列化
                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSArray *array=(NSArray *)dict[@"retData"];
                                   for (NSDictionary *cityDict in array) {
                                       WeatherCity *city=[WeatherCity WeatherCityWithDict:cityDict];
                                       [self.cities addObject:city];
                                   }
                                [self.tableView reloadData];
                               }
                           }];
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
    WeatherCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCity_Cell"];
    cell.city=city;
    return cell;
}

@end
