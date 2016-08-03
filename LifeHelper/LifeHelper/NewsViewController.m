//
//  NewsViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/3.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://3g.163.com/touch/"]];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:webView];
    NSURL *url=[NSURL URLWithString:self.url];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
