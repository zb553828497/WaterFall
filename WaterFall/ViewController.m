//
//  ViewController.m
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"
#import "ZBWaterFallLayout.h"
@interface ViewController ()<UICollectionViewDataSource>

@end

static NSString *const ZBShopId = @"shop";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建布局
    ZBWaterFallLayout *layout = [[ZBWaterFallLayout alloc] init];
    // 2.创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 3.注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZBShopId];
 }
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZBShopId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    NSInteger tag = 10;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%zd",indexPath.item];
    [label sizeToFit];
    return cell;
}
























@end
