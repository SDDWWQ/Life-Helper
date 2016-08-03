//
//  NewsTableViewCell.m
//  LifeHelper
//
//  Created by shadandan on 16/8/3.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface NewsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureWidthConstraint;
@end
@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setNews:(NewsModel *)news{
    _news=news;
    
    //如果没有图片，改变图片约束
    if([news.image_url isEqual:@""]){
        //设置图片宽的约束是0
        self.pictureWidthConstraint.constant=0;
    }else{
        self.pictureWidthConstraint.constant=80;
        NSURL *imgUrl=[NSURL URLWithString:news.image_url];
        [self.pictureView sd_setImageWithURL:imgUrl];
    }
    self.titleLabel.text=self.news.title;
    self.detailLabel.text=self.news.abstract;
}
@end
