//
//  MoreTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/5.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "MoreTableViewController.h"
#import "AboutUsViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
@interface MoreTableViewController ()<UITableViewDataSource>

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //保存团购城市信息的
//    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/cities";
//    NSString *httpArg = @"";
//    [self request: httpUrl withHttpArg: httpArg];
}


//-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
//    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
//    NSURL *url = [NSURL URLWithString: urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
//    [request setHTTPMethod: @"GET"];
//    [request addValue: @"您自己的apikey" forHTTPHeaderField: @"apikey"];
//    [NSURLConnection sendAsynchronousRequest: request
//                                       queue: [NSOperationQueue mainQueue]
//                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
//                               if (error) {
//                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
//                               } else {
//                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"HttpResponseCode:%ld", responseCode);
//                                   NSLog(@"HttpResponseBody %@",responseString);
//                                   NSString *documentPath = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
//                                   NSString *path;
//                                   path=[[NSBundle mainBundle]pathForResource:@"GPCities" ofType:@"plist"];
//                                   NSError *error;
//                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                   [dict writeToFile:path atomically:YES];
//                                   NSLog(@"%@",path);//注意不要在真机上调试运行，要在模拟器上运行，否则找不到保存的路径
//
//                               }
//                           }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //提示框插件
        [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeBlack];//灰色背景效果
        [SVProgressHUD showWithStatus:@"正在清除"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            float tmpSize=[[SDImageCache sharedImageCache] getSize];
            NSLog(@"%f",tmpSize);
            [[SDImageCache sharedImageCache] clearDisk];
            NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize/1000000] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize/1000];
            NSLog(@"%@",clearCacheName);
            [SVProgressHUD showSuccessWithStatus:clearCacheName ];
            [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeBlack];//灰色背景效果
            //取消提示框
            [SVProgressHUD dismissWithDelay:1.0];
        });

        [tableView deselectRowAtIndexPath:indexPath animated:NO];

      
        //self.tableView.
    }
}
@end
