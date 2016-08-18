//
//  LockView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/18.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "LockView.h"
#import "HomeTabBarController.h"
@interface LockView()
@property(nonatomic,strong)NSMutableArray *nineBtn;
@property(nonatomic,strong)NSMutableArray *lineBtn;
@property(nonatomic,assign)CGPoint currentPoint;//手指当前的位置

@end

@implementation LockView

-(NSMutableArray *)nineBtn{
    if(!_nineBtn){
        _nineBtn=[NSMutableArray array];
        //创建9个按钮
        for (int i=0; i<9; i++) {
            UIButton *btn=[[UIButton alloc]init];
            [btn setImage:[UIImage imageNamed:@"lock_btn_none"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"lock_btn_sel"] forState:UIControlStateHighlighted];//发现松手就变回原来的状态了
            //所以关闭用户交互，让其不可点击，用touchesMove来实现
            btn.userInteractionEnabled=NO;
            //设置密码错误状态的图片
            [btn setBackgroundImage:[UIImage imageNamed:@"lock_btn_error"] forState:UIControlStateSelected];
            btn.tag=i+1;//设置按钮对应的号码，用于判断密码是否正确
            [self addSubview:btn];
            [_nineBtn addObject:btn];
        }
    }
    return _nineBtn;
}
-(NSMutableArray *)lineBtn{
    if (!_lineBtn) {
        _lineBtn=[NSMutableArray array];
    }
    return _lineBtn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //设置9个按钮的frame
    CGFloat margin=10;
    CGFloat w=(self.bounds.size.width-margin*4)/3;
    CGFloat h=w;
    for (int i=0; i<9; i++) {
        CGFloat x=margin+i%3*(margin+w);
        CGFloat y=margin+i/3*(margin+h);
        UIButton *btn=self.nineBtn[i];//调用懒加载，创建9个按钮
        [btn setFrame:CGRectMake(x, y, w, h)];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=touches.anyObject;
    CGPoint p=[touch locationInView:touch.view];
    for (int i=0; i<9; i++) {
        UIButton *btn=self.nineBtn[i];
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.highlighted=YES;
        }
    }

}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=touches.anyObject;
    CGPoint p=[touch locationInView:touch.view];
    self.currentPoint=p;
    for (int i=0; i<9; i++) {
        UIButton *btn=self.nineBtn[i];
        if (CGRectContainsPoint(btn.frame, p)) {
            if (![self.lineBtn containsObject:btn]) {
                btn.highlighted=YES;
                [self.lineBtn addObject:btn];
            }
        }
    }
    [self setNeedsDisplay];

}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 //
     UIBezierPath *path=[UIBezierPath bezierPath];
     [[UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0]set];//设置线的颜色
     [path setLineWidth:5];
     [path setLineCapStyle:kCGLineCapRound];
     [path setLineJoinStyle:kCGLineJoinRound];
     for (int i=0; i<self.lineBtn.count; i++) {
         UIButton *btn=self.lineBtn[i];
         //NSLog(@"%ld",btn.tag);
         if (i==0) {
             [path moveToPoint:btn.center];
         }else{
             [path addLineToPoint:btn.center];
         }
     }
     //判断连线的数组是不是有元素，如果不判断，当没有元素时会报一个没有起点的错误
     if (self.lineBtn.count!=0) {
         //往手指的位置连线
         [path addLineToPoint:self.currentPoint];
     }

     [path stroke];

 }
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setUserInteractionEnabled:NO];//不允许用户交互
    NSString *password=@"";
     NSLog(@"%ld",self.lineBtn.count);
    for (UIButton *btn in self.lineBtn) {
        password=[password stringByAppendingString:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
    NSLog(@"%@",password);
    NSLog(@"%@",self.gesturePassword);
    if (self.gesturePassword==nil) {//设置手势密码
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:password forKey:@"gesturePassword"];
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeTabBarController *tabvc=[storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
        self.window.rootViewController=tabvc;
        [self.window makeKeyAndVisible];

        
    }else if (![password isEqualToString:self.gesturePassword]) {//密码错误
        for (UIButton *btn in self.lineBtn) {
            btn.highlighted=NO;
            btn.selected=YES;//如果没效果，就把highlighted改成NO，因为它俩冲突
            
        }
        //将当前点设置为lineBtn数组的最后一个元素的center,为了让超出部分的线松手后消失
        self.currentPoint=[[self.lineBtn lastObject] center];
        [self setNeedsDisplay];
        //延时两秒再取消
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [self clear];
        });

    }
    else{//密码正确
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeTabBarController *tabvc=[storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
            self.window.rootViewController=tabvc;
            [self.window makeKeyAndVisible];
    }
   
}
-(void)clear{
    for (UIButton *btn in self.nineBtn) {
        btn.highlighted=NO;
        btn.selected=NO;
    }
    [self.lineBtn removeAllObjects];
    
    [self setUserInteractionEnabled:YES];//开启用户交互
    [self setNeedsDisplay];
}
@end
