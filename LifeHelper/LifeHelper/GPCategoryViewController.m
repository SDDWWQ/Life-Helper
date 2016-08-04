//
//  GPCategoryViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCategoryViewController.h"
#import "GPCategoryView.h"
#import "GPCategory.h"
#import "GroupPurchaseTableViewController.h"
@interface GPCategoryViewController ()<GPCategoryClickDelegate>
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property(nonatomic,strong)NSArray *categories;
@end

@implementation GPCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取团购类别，已储存在plist中
//    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/categories";
//    NSString *httpArg = @"";
//    [self request: httpUrl withHttpArg: httpArg];
    [self loadCategoryXib];
    
}

#pragma mark-懒加载
-(NSArray *)categories{
    if (!_categories) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"GPCategories" ofType:@"plist"];
        NSMutableArray *tempArray=[NSMutableArray array];
        NSArray *dictArray=[NSArray arrayWithContentsOfFile:path];
        //NSLog(@"%@",dictArray);
        for (NSDictionary *dict in dictArray) {
            GPCategory *cat=[GPCategory GPCatWithDict:dict];
            [tempArray addObject:cat];
        }
        _categories=tempArray;
    }
    return _categories;
}
//加载类别图标
-(void)loadCategoryXib{
    CGFloat margin=5;
    CGFloat catW=50;
    CGFloat catH=80;
    CGFloat leftMargin=(self.view.frame.size.width-5*catW-4*margin)*0.5;
    for (int i=0; i<5; i++) {
        GPCategoryView *categoryView=[GPCategoryView categoryView];
        categoryView.frame=CGRectMake(leftMargin+i*(catW+margin), margin, catW, catH);
        GPCategory *cat=self.categories[i];
        categoryView.title=cat.cat_name;
        categoryView.picture=cat.icon;
        categoryView.delegate=self;
        [self.categoryView addSubview:categoryView];
    }
    for (int i=5; i<10; i++) {
        GPCategoryView *categoryView=[GPCategoryView categoryView];
        categoryView.frame=CGRectMake(leftMargin+(i-5)*(catW+margin), 2*margin+catH, catW, catH);
        GPCategory *cat=self.categories[i];
        categoryView.title=cat.cat_name;
        categoryView.picture=cat.icon;
        categoryView.delegate=self;
        [self.categoryView addSubview:categoryView];
    }
    

}

#pragma mark-GPCategoryView的代理方法
-(void)jumpToGPTableView:(GPCategoryView *)GPCat withCatId:(NSNumber *)cat_id{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据storyBoardID来获取我们要切换的视图,当storyboard中的视图前面不与任何界面相关联时，必须以这种方式从storyboard加载视图，不能直接从控制器跳转。
    GroupPurchaseTableViewController *GPtcv= [story instantiateViewControllerWithIdentifier:@"GPTableView"];
    GPtcv.cat_id=cat_id;//传递一级类别编号
    [self.navigationController pushViewController:GPtcv animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*获取团购类别，已储存在plist中
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
                                   NSString *path=[[NSBundle mainBundle]pathForResource:@"GPCategories" ofType:@"plist"];
                                   NSError *error;
                                   NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   [dict writeToFile:path atomically:YES];
                                   NSLog(@"%@",path);
                               }
                           }];
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
