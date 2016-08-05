//
//  GroupPurchaseTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "GroupPurchaseTableViewController.h"
#import "Goods.h"
#import "GPTableViewCell.h"
#import "GPShop.h"
#import "GPHeaderView.h"
#import "CCLocationManager.h"//用于定位
#import "GPDealViewController.h"

@interface GroupPurchaseTableViewController ()<UITableViewDataSource,GPHeaderViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;
}

@property(nonatomic,strong)NSMutableArray *shops;

@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,getter=isnull,assign)Boolean Null;

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
    //self.tableView.sectionHeaderHeight=UITableViewAutomaticDimension;
    //6.3之后的版本（包括6.3）需要预设高度
    //self.tableView.estimatedSectionHeaderHeight=50;
    
        if (IS_IOS8) {
            [UIApplication sharedApplication].idleTimerDisabled = TRUE;
            locationmanager = [[CLLocationManager alloc] init];
            [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
            [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
            locationmanager.delegate = self;
            NSLog(@"当前调用线程：%@", [NSThread currentThread]);
        }
        if (IS_IOS8) {
            //真机调试才会显示
            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                //NSLog(@"%f %f",locationCorrrdinate.longitude,locationCorrrdinate.latitude);
                //            self.longitude=[NSNumber numberWithDouble:locationCorrrdinate.longitude];
                //            self.latitude=[NSNumber numberWithDouble:locationCorrrdinate.latitude];
                
                self.longitude=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
                self.latitude=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
                //NSLog(@"str=%@",self.longitude);
                
                //必须在这里调用，放在外面的话url获取不到位置信息
                [self searchGoods];
                
            }];
            [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
                NSLog(@"%@",cityString);
            }];
            
        }
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
    if (self.isnull) {
        return 1;
    }
    return self.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isnull) {
        return 1;
    }
    GPShop *shop=self.shops[section];
    return shop.deals.count;
}
-(void)searchGoods{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    //NSString *httpArg = @"city_id=100010000&cat_ids=326&subcat_ids=962%2C994&district_ids=394%2C395&bizarea_ids=1322%2C1328&location=116.418993%2C39.915597&keyword=%E4%BF%8F%E6%B1%9F%E5%8D%97&radius=3000&page=1&page_size=5&deals_per_shop=10";
    
    //NSString * httpArg = [NSString stringWithFormat:@"city_id=1300020000&location=%@%%2C%@&cat_ids=%@",self.longitude,self.latitude,self.cat_id];
    NSString * httpArg = [NSString stringWithFormat:@"city_id=100010000&cat_ids=%@",self.cat_id];
    NSLog(@"%@",httpArg);
    [self request: httpUrl withHttpArg: httpArg];
    
}


-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   //json序列化
                                   NSError *error;
                                   //json反序列化
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   dict=dict[@"data"];
   
    if([dict isEqual:[NSNull null]]){
        self.Null=1;
     NSLog(@"%d",self.isnull);
    }
    else{
        int num=dict[@"total"];
        NSArray *array=dict[@"shops"];
        for (NSDictionary *dict in array) {
            GPShop *shop=[GPShop ShopWithDict:dict];
            [self.goods addObject:shop];
        }
    }
    //重新加载tableView
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isnull) {
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.textLabel.text=@"没有找到符合条件的记录";
        [cell.textLabel textAlignment];
        return cell;
    }
    //NSLog(@"重新加载了");
    GPShop *shops=self.shops[indexPath.section];
    Goods *good=shops.deals[indexPath.row];
    static NSString *ID=@"Good_Cell";
    GPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //3.设置单元格数据
    cell.good=good;
    return cell;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    GPShop *shop=self.shops[section];
//    GPHeaderView *header=[GPHeaderView headerView];
//    //header.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
//    header.shop=shop;
//    //header.deleagte=self;
//    header.tag=section;//将组号保存到tag中用于刷新组
//    return header;
//    static NSString *ID=@"GPHeader";
//    UITableViewHeaderFooterView *headerView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
//    headerView.textLabel.text=shop.shop_name;
//    return headerView;
//    
//}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    GPShop *shop=self.shops[section];
    return shop.shop_name;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GPShop *shop=self.shops[indexPath.section];
    Goods *good=shop.deals[indexPath.row];
    GPDealViewController *vc=[[GPDealViewController alloc]init];
    vc.url=good.deal_url;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
