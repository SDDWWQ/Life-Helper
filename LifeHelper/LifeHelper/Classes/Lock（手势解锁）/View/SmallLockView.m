//
//  SmallLockView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/18.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "SmallLockView.h"

@implementation SmallLockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setGesturePassword:(NSString *)gesturePassword{
    _gesturePassword=gesturePassword;
    for (int i=0; i<9; i++) {
        UIButton *btn=[[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"lock_btn_none"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"lock_btn_sel"] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled=NO;
        btn.tag=i+1;//设置按钮对应的号码，用于判断密码是否正确
        [self addSubview:btn];
    }
}
@end
