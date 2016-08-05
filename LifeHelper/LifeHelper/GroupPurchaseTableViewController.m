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
#import "GPShop.h"
#import "GPHeaderView.h"
@interface GroupPurchaseTableViewController ()<UITableViewDataSource,GPHeaderViewDelegate>
@property(nonatomic,strong)NSMutableArray *shops;

@end

@implementation GroupPurchaseTableViewController
//改成Viewwillload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    // 1.设置自动header计算高度
    self.tableView.sectionHeaderHeight=UITableViewAutomaticDimension;
    //6.3之后的版本（包括6.3）需要预设高度
    self.tableView.estimatedSectionHeaderHeight=40;

    [self searchGoods];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-懒加载初始化
-(NSMutableArray *)goods{
    if (!_shops) {
        //必须得初始化
        _shops=[NSMutableArray array];
    }
    return _shops;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GPShop *shop=self.shops[section];
    return shop.deals.count;
}
-(void)searchGoods{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    //NSString *httpArg = @"city_id=100010000&cat_ids=326&subcat_ids=962%2C994&district_ids=394%2C395&bizarea_ids=1322%2C1328&location=116.418993%2C39.915597&keyword=%E4%BF%8F%E6%B1%9F%E5%8D%97&radius=3000&page=1&page_size=5&deals_per_shop=10";
    NSString *httpArg = @"city_id=100010000&cat_ids=326";
    [self request: httpUrl withHttpArg: httpArg];
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
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   //json序列化
                                   NSError *error;
                                   //json反序列化
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   dict=dict[@"data"];
                                   int num=dict[@"total"];
                                   
                                   NSArray *array=dict[@"shops"];
                                   for (NSDictionary *dict in array) {
                                       GPShop *shop=[GPShop ShopWithDict:dict];
                                       [self.goods addObject:shop];
                                   }
//                                   Goods *good=[Goods GoodWithDict:array[0]];
//                                   self.goods addObject:good];
//                                   for (int i=0; i<5; i++) {
//                                       [self.goods addObject:good];
//                                   }
                                   //重新加载tableView
                                   [self.tableView reloadData];

                               }
                           }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"重新加载了");
    GPShop *shops=self.shops[indexPath.section];
    Goods *good=shops.deals[indexPath.row];
    static NSString *ID=@"Good_Cell";
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //3.设置单元格数据
    cell.good=good;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GPShop *shop=self.shops[section];
    GPHeaderView *header=[GPHeaderView headerView];
    header.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    header.shop=shop;
    //header.deleagte=self;
    header.tag=section;//将组号保存到tag中用于刷新组
    return header;
    
}

@end
