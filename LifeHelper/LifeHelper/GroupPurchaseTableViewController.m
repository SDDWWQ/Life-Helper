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
@property(nonatomic,strong)NSMutableArray *goods;

@end

@implementation GroupPurchaseTableViewController
//改成Viewwillload
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
#pragma mark-懒加载初始化
-(NSMutableArray *)goods{
    if (!_goods) {
        //必须得初始化
        _goods=[NSMutableArray array];
    }
    return _goods;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.goods.count;
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
                                   //json反序列化
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSArray *array=dict[@"deals"];
                                   Goods *good=[Goods GoodWithDict:array[0]];
                                   for (int i=0; i<5; i++) {
                                       [self.goods addObject:good];
                                   }
                                   //重新加载tableView
                                   [self.tableView reloadData];
//                               }];
                                   
                               }
                           }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"重新加载了");
    Goods *good=self.goods[indexPath.row];
    static NSString *ID=@"Good_Cell";
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //3.设置单元格数据
    cell.good=good;
    return cell;
}

@end
