//
//  GPTableViewCell.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface GPTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLabel;
@end
@implementation GPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGood:(Goods *)good{
    _good=good;
    self.titleLabel.text=good.title;
    int price=[good.current_price floatValue];
    self.priceLabel.text=[NSString stringWithFormat:@"¥%d",price/100];
    self.sellCountLabel.text=[NSString stringWithFormat:@"已售：%@",good.sale_num];
    
    //从网址获取图片
    NSURL *pictureUrl=[NSURL URLWithString:good.image];
    //NSLog(@"%@",pictureUrl);
//    NSData *pictureData=[NSData dataWithContentsOfURL:pictureUrl];
//    UIImage *pictureImage= [UIImage imageWithData:pictureData];
//    self.pictureView.image=pictureImage;
    
    //使用SDWebImage框架缓存UIImageView的图片
    UIImage *defaultAvatar=[UIImage imageNamed:@"defaultAvatar.jpg"];//默认图片
    //格式为[UIImageView属性 sd_setImageWithURL:图片url placeholderImage:UIImage格式的默认图片];
    [self.pictureView sd_setImageWithURL:pictureUrl placeholderImage:defaultAvatar];


}
@end
