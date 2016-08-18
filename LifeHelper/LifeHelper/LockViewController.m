//
//  LockViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/18.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"
@interface LockViewController ()
@property(nonatomic,copy)NSString *gesturePassword;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet LockView *lockView;
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.gesturePassword=[defaults objectForKey:@"gesturePassword"];
    if (self.gesturePassword==nil) {
        self.label.text=@"绘制解锁图案";
    }else{
        self.label.text=@"请输入手势密码";
       
    }
    self.lockView.gesturePassword=self.gesturePassword;
    NSLog(@"%@",self.gesturePassword);
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
