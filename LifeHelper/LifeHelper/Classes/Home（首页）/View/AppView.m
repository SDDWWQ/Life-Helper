//
//  AppView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/21.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "AppView.h"
@interface AppView()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation AppView
-(void)setAppDict:(NSDictionary *)appDict{
    UIImage *image=[UIImage imageNamed:appDict[@"icon"]];
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//让图片不渲染成系统定义的颜色
    [self.imageBtn setImage:image forState:UIControlStateNormal];
    self.titleLabel.text=appDict[@"name"];
}
+(instancetype)appView{
    return [[NSBundle mainBundle]loadNibNamed:@"AppView" owner:nil options:nil][0];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.appBlock) {//跳转到指定控制器，通过block让主控制器执行
        self.appBlock();
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
