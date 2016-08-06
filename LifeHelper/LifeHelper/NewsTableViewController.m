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
//#import "MJExtension.h"
@interface NewsTableViewController ()<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *newsArray;
@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //提示框插件
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeBlack];//灰色背景效果
    [SVProgressHUD showWithStatus:@"正在加载"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //取消提示框
        [SVProgressHUD dismiss];
        });
    [self loadData];
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
#pragma mark-懒加载
-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray=[NSMutableArray array];
    }
    return _newsArray;
}


-(void)loadData{
    NSString *httpUrl = @"http://apis.baidu.com/songshuxiansheng/news/news";
    NSString *httpArg = @"";
    [self request: httpUrl withHttpArg: httpArg];
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"d2dfec542a6c211fa932b11248360ef9" forHTTPHeaderField: @"apikey"];
     NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];                                                                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //NSLog(@"HttpResponseCode:%ld", responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   NSError *error;
                                   //json反序列化
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSArray *array=dict[@"retData"];
                                   for (NSDictionary *newsDict in array) {
                                       NewsModel *news=[NewsModel NewsWithDict:newsDict];
                                        [self.newsArray addObject:news];
                                   }
                                   [self.tableView reloadData];
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
    vc.url=news.url;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
