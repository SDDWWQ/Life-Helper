//
//  GroupPurchaseTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GroupPurchaseTableViewController.h"
#import "Goods.h"
#import "GPTableViewCell.h"
@interface GroupPurchaseTableViewController ()<UITableViewDataSource>
@property(nonatomic,strong)Goods *good;


@end

@implementation GroupPurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/shopdeals";
    NSString *httpArg = @"shop_id=1745896";
    [self request: httpUrl withHttpArg: httpArg];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
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
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   //json序列化
                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSArray *array=dict[@"deals"];
//                                   [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                   Goods *good=[[Goods alloc]init];
                                   //[good setValuesForKeysWithDictionary:array[0]];
                                   good.title=array[0][@"title"];
                                   good.current_price=array[0][@"current_price"];
                                   good.image=array[0][@"image"];
                                   good.sale_num=array[0][@"sale_num"];
                                   NSLog(@"%@",good.title);
                                   _good=good;
                                   //重新加载tableView
                                   [self.tableView reloadData];
//                               }];
                                   
                               }
                           }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"重新加载了");
    Goods *good=self.good;
    NSString *ID=@"Good_Cell";
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //3.设置单元格数据
    cell.good=good;
    return cell;
}

@end
