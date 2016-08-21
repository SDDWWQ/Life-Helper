//
//  CategoryTableViewController.h
//  LifeHelper
//
//  Created by shadandan on 16/8/20.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewController : UITableViewController
@property(nonatomic,copy)NSString *plistName;//要加载的plist的名称
@property(nonatomic,copy)void(^block)(NSString *);
@end
