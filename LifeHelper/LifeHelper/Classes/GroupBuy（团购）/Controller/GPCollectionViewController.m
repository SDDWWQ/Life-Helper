//
//  GPCollectionViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/26.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "GPCollectionViewController.h"
#import "GPCategory.h"
#import "GPCollectionViewCell.h"
#import "GroupPurchaseTableViewController.h"
@interface GPCollectionViewController ()
@property(nonatomic,strong)NSArray *categories;
@end

@implementation GPCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    //创建流水布局
    UINib *nib=[UINib nibWithNibName:@"GPCollectionViewCell" bundle:nil];//加载xib的另一种方式
    //注册单元格
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //一个集合视图如果没有布局，是没有用途的。因此，我们需要创建布局。添加如下代码到viewDidLoad方法的底部。
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setItemSize:CGSizeMake(100, 100)];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    
    //[self.collectionView setCollectionViewLayout:flowLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-懒加载
-(NSArray *)categories{
    if (!_categories) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"GPCategories" ofType:@"plist"];
        NSMutableArray *tempArray=[NSMutableArray array];
        NSArray *dictArray=[NSArray arrayWithContentsOfFile:path];
        //NSLog(@"%@",dictArray);
        for (NSDictionary *dict in dictArray) {
            GPCategory *cat=[GPCategory GPCatWithDict:dict];
            [tempArray addObject:cat];
        }
        _categories=tempArray;
    }
    return _categories;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GPCategory *category=self.categories[indexPath.row];
    GPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.category=category;
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GPCategory *category=self.categories[indexPath.row];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据storyBoardID来获取我们要切换的视图,当storyboard中的视图前面不与任何界面相关联时，必须以这种方式从storyboard加载视图，不能直接从控制器跳转。
    GroupPurchaseTableViewController *GPtcv= [story instantiateViewControllerWithIdentifier:@"GPTableView"];
    GPtcv.cat_id=category.cat_id;//传递二级类别编号
    //NSLog(@"cat_id=%@",cat_id);
    [self.navigationController pushViewController:GPtcv animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
