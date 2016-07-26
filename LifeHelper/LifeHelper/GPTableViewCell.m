//
//  GPTableViewCell.m
//  LifeHelper
//
//  Created by shadandan on 16/7/25.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPTableViewCell.h"
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
    NSURL *pictureUrl=[NSURL URLWithString:good.image];
    NSLog(@"%@",pictureUrl);
    NSData *pictureData=[NSData dataWithContentsOfURL:pictureUrl];
    UIImage *pictureImage= [UIImage imageWithData:pictureData];
    self.pictureView.image=pictureImage;
}
@end
