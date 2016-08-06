//
//  GPHeaderView.m
//  LifeHelper
//
//  Created by shadandan on 16/8/4.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPHeaderView.h"
@interface GPHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@end
@implementation GPHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setShop:(GPShop *)shop{
    self.shopNameLabel.text=shop.shop_name;
//    if (shop.address) {
//        self.shopAddressLabel.text=shop.address;
//    }
//    if (shop.per_price) {
//        int price=[shop.per_price intValue];
//        NSString *priceStr=[NSString stringWithFormat:@"人均：￥%f",price*0.001];
//        self.averagePriceLabel.text=priceStr;
//    }
    
//    if (shop.average_score) {
//        self.averageScoreLabel.text=[NSString stringWithFormat:@"综合评分：%@",shop.average_score];
//
//    }
    self.distanceLabel.text=[NSString stringWithFormat:@"距离%d m",[shop.distance intValue]];
}
+(instancetype)headerView{
    return [[NSBundle mainBundle]loadNibNamed:@"GPHeaderView" owner:nil options:nil][0];

}
@end
