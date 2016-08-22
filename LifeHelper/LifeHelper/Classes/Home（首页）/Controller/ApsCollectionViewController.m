//
//  AppCollectionViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/21.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "ApsCollectionViewController.h"
#import "ApsCollectionViewCell.h"
@interface ApsCollectionViewController ()
@property(nonatomic,strong)NSArray *apps;
@end

@implementation ApsCollectionViewController

static NSString * const reuseIdentifier = @"App_Cell";
-(instancetype)init{
    return [super initWithCollectionViewLayout:[self layout]];
}
-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    return [super initWithCollectionViewLayout:[self layout]];
}
-(UICollectionViewFlowLayout *)layout{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(80, 80);
    return layout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //创建流水布局
    UINib *nib=[UINib nibWithNibName:@"ApsCollectionViewCell" bundle:nil];//加载xib的另一种方式
    //注册单元格
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.apps);
    self.collectionView.backgroundColor=[UIColor whiteColor];
}
-(NSArray *)apps{
    if (!_apps) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"app" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        _apps=array;
    }
    return _apps;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"hjjjjkh");
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",self.apps.count);
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //缓存池找
   ApsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //AppCollectionViewCell *cell=[AppCollectionViewCell appCell];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

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
