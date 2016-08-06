//
//  GPFooterView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/5.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPFooterView.h"
@interface GPFooterView()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation GPFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)footerView{
    return [[NSBundle mainBundle]loadNibNamed:@"GPFooterView" owner:nil options:nil][0];
}
-(void)setShop:(GPShop *)shop{
    _shop=shop;
    [self.btn setTitle:[NSString stringWithFormat:@"其他%d个团购",[shop.deal_num intValue]-2] forState:UIControlStateNormal];
    
}
-(void)setDeals:(NSNumber *)deals{
    
}
- (IBAction)btnClick:(id)sender {
    self.shop.visible=1;//改变可见状态
    if ([self.delegate respondsToSelector:@selector(footerViewClick:)]) {
        [self.delegate footerViewClick:self];
    }
}
@end
