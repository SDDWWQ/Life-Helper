//
//  GPCollectionViewCell.m
//  LifeHelper
//
//  Created by shadandan on 16/8/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCollectionViewCell.h"
@interface GPCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
@implementation GPCollectionViewCell
//-(instancetype)initWithFrame:(CGRect)frame{
//    self=[super initWithFrame:frame];
//    if (self) {
//        self= [[NSBundle mainBundle]loadNibNamed:@"GPCollectionViewCell" owner:nil options:nil][0];
//    }
//    return self;
//}
-(void)setCategory:(GPCategory *)category{
    _category=category;
    self.label.text=self.category.cat_name;
    self.iconView.image=[UIImage imageNamed:self.category.icon];
}
@end
