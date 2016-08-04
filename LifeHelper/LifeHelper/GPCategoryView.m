//
//  GPCategoryView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCategoryView.h"
@interface GPCategoryView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;

@end
@implementation GPCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setPicture:(NSString *)picture{
    _picture=picture;
    UIImage *image=[UIImage imageNamed:picture];
    [self.pictureBtn setImage:image forState:UIControlStateNormal];
}
-(void)setTitle:(NSString *)title{
    _title=title;
    self.titleLabel.text=title;
}
-(void)setCat_id:(NSNumber *)cat_id{
    _cat_id=cat_id;
}
+(instancetype)categoryView{
    return [[NSBundle mainBundle]loadNibNamed:@"GroupPurchaseCategory" owner:nil options:nil][0];
}
- (IBAction)btnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jumpToGPTableView:withCatId:)]) {
        [self.delegate jumpToGPTableView:self withCatId:self.cat_id];
    }
}
@end
