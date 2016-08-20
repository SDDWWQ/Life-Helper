//  类别table公用的tableviewcontroller
//  CategoryTableViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/20.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController ()
@property(nonatomic,strong)NSArray *groups;
@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_dealsmap_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=item;
}


//重写控制器的init方法，使其无论是什么方式创建的，最终都被我改成group方式创建tableView
-(instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}
-(instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

//懒加载
-(NSArray *)groups{
    if (!_groups) {
        NSString *path=[[NSBundle mainBundle]pathForResource:self.plistName ofType:@"plist"];//加载plist
        _groups=[NSArray arrayWithContentsOfFile:path];
    }
    return _groups;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *group=self.groups[section];
    NSArray *items=group[@"items"];
    return items.count;
}
-(void)back{
    
    [self transformAnimate];//调用自定义转场动画
    
    [self.navigationController popViewControllerAnimated:NO];
}
//自定义转场动画
-(void)transformAnimate{
    CATransition *anim=[CATransition animation];
    anim.type=kCATransitionPush;
    anim.subtype=kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:anim forKey:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSDictionary *group=self.groups[indexPath.section];
    NSArray *items=group[@"items"];
    NSDictionary *item=items[indexPath.row];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    NSString *accessaryView=item[@"accessaryView"];//获取要显示的accessaryView的控件类型
    Class claz=NSClassFromString(accessaryView);//将字符串转换成类类型
    id obj=[[claz alloc]init];//创建对象，因为不一定是什么类型，所以用id接收,可以使任何控件类型，例如switch等
    //判断真实类型
    if ([obj isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView=(UIImageView *)obj;//强制转换
        NSString *imageName=item[@"accessaryContent"];
        imageView.image=[UIImage imageNamed:imageName];//设置图片
        [imageView sizeToFit];//设置大小和图片大小一样
    }
    cell.textLabel.text=item[@"name"];
    cell.accessoryView=obj;
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *group=self.groups[section];
    return group[@"header"];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSDictionary *group=self.groups[section];
    return group[@"footer"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *group=self.groups[indexPath.section];
    NSArray *items=group[@"items"];
    NSDictionary *item=items[indexPath.row];
    if (item[@"channelId"]&&[item[@"channelId"] length]>0) {//判断是否存在这个key，且是否有内容
         NSString *categoryId=item[@"channelId"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:categoryId forKey:@"newsCategory"];
        [defaults synchronize];//立即存入
    }
   
    
    /*//用于向后跳转的
    if(item[@"targetVC"]&&[item[@"targetVC"] length]>0){
    NSString *targetVC=item[@"targetVC"];
    Class claz=NSClassFromString(targetVC);
    UIViewController *vc=[[claz alloc]init];
     vc.navigationItem.title=item[@"title"];//设置跳转到的控制器的title
    [self.navigationController pushViewController:vc animated:YES];
    if (<#condition#>) {
        <#statements#>
    }
     }
    */
    //向前跳转的
    [self transformAnimate];//调用自定义转场动画
    [self.navigationController popViewControllerAnimated:YES];
}


@end
