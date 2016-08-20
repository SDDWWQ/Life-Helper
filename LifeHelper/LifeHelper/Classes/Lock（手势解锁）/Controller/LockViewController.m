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
    //NSLog(@"%@",self.gesturePassword);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
