//
//  NewsTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "NewsViewController.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "CategoryTableViewController.h"
//#import "MJExtension.h"
@interface NewsTableViewController ()<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,copy)NSString *newsCategory;
@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *newsCategory=[ud objectForKey:@"newsCategory"];
    //NSLog(@"%@",newsCategory);
    self.newsCategory=newsCategory;
    //提示框插件
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeBlack];//灰色背景效果
    [SVProgressHUD showWithStatus:@"正在加载"];
    //开启异步线程，加载数据
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self loadData];
        //取消提示框
        [SVProgressHUD dismiss];
    });
    //必须设置自动计算高度，否则cell的高度和storyboard中的高度一样，不会自动调整
    // 1.设置自动计算高度
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    //6.3之后的版本（包括6.3）需要预设高度
    self.tableView.estimatedRowHeight=100;
    
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.newsArray=nil;
        [self loadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //获取当前最后一行的行号
        NSIndexPath *lastRowIndexPath=[NSIndexPath indexPathForRow:self.newsArray.count-1 inSection:0];
        
        //NSLog(@"%ld",lastRowIndexPath.row);
        //加载更多数据
        [self loadData];
        //把之前的最后一行滚到中间
        [self.tableView scrollToRowAtIndexPath:lastRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    }];

}
//-(void)viewWillAppear:(BOOL)animated{
//    //NSLog(@"ghgghhg");
//    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
//    NSString *newsCategory=[ud objectForKey:@"newsCategory"];
//    if (newsCategory!=self.newsCategory) {
//        //NSLog(@"gggggg");
//        self.newsArray=nil;
//        [self loadData];
//    }
//
//}
#pragma mark-懒加载
-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray=[NSMutableArray array];
    }
    return _newsArray;
}


-(void)loadData{

    if (self.newsCategory==nil) {
        self.newsCategory=@"5572a109b3cdc86cf39001db";
    }
    NSString *httpUrl = @"http://apis.baidu.com/showapi_open_bus/channel_news/search_news";
    NSString *httpArg = [NSString stringWithFormat:@"channelId=%@&page=1&needContent=0&needHtml=0",self.newsCategory];
    //@"channelId=5572a109b3cdc86cf39001db&channelName=%E5%9B%BD%E5%86%85%E6%9C%80%E6%96%B0&title=%E4%B8%8A%E5%B8%82&page=1&needContent=0&needHtml=0";
    [self request: httpUrl withHttpArg: httpArg];
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
    NSURLSession *session=[NSURLSession sharedSession];
    //显示加载提示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //NSString *dataStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",dataStr);
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dict=dict[@"showapi_res_body"];
            dict=dict[@"pagebean"];
            NSArray *array=dict[@"contentlist"];
            //NSLog(@"%@",array);
            for (NSDictionary *tempdict in array) {
                NewsModel *news=[NewsModel NewsWithDict:tempdict];
                [self.newsArray addObject:news];
            }
            //NSLog(@"%@",dataStr);
        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
        
        //NSLog(@"%ld",self.newsArray.count);
        // NSURLSession的方法是在异步执行的，所以更新UI回到主线程，非常重要
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//取消网络请求显示
            [self.tableView reloadData];
        });

    }];
    
    [dataTask resume];//恢复线程，启动任务
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
    //NSLog(@"%ld",self.newsArray.count);
    return self.newsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *news=self.newsArray[indexPath.row];
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"News_Cell"];
    cell.news=news;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *news=self.newsArray[indexPath.row];
    NewsViewController *vc=[[NewsViewController alloc]init];
    vc.url=news.link;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)categoryClick:(id)sender {

    //自定义转场动画
    CATransition *anim=[CATransition animation];
    anim.type=kCATransitionReveal;
    anim.subtype=kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:anim forKey:nil];
    CategoryTableViewController *catTVC=[[CategoryTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    catTVC.navigationItem.title=@"新闻频道";
    catTVC.plistName=@"NewsCategory";//要加载的plist的名称
    catTVC.block=^(NSString *newsCategory){
        self.newsCategory=newsCategory;
        self.newsArray=nil;
        [self loadData];
    };
    [self.navigationController pushViewController:catTVC animated:NO];
}

@end
