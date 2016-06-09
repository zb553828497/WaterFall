//
//  ViewController.m
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"
#import "ZBWaterFallLayout.h"
#import "ZBShopCollectionViewCell.h"
#import "ZBShop.h"
#import "MJExtension.h"

@interface ViewController ()<UICollectionViewDataSource,ZBWaterFallLayoutDelegate>
/** 所有的商品数据 */
@property(nonatomic,strong)NSMutableArray *shops;
@end

static NSString *const ZBShopId = @"shop";
@implementation ViewController

-(NSMutableArray *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 1.创建布局
    ZBWaterFallLayout *layout = [[ZBWaterFallLayout alloc] init];
    layout.delegate = self;
    // 2.创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 3.注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBShopCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ZBShopId ];
    
    NSArray *shops = [ZBShop objectArrayWithFilename:@"Clothes.plist"];
    [self.shops addObjectsFromArray:shops];
    // 注意:图片的背景是collectionView不是当前控制器，所以设置背景应该用collectionView.backgroundColor
    collectionView.backgroundColor = [UIColor whiteColor];
 }
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shops.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZBShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZBShopId forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

#pragma mark - ZBWaterFallLayoutDelegate
-(CGFloat)WaterFallLayout:(ZBWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index ItemWidth:(CGFloat)itemWidth{
    ZBShop *shop = self.shops[index];
    // 交叉相成，计算等比例缩放之后的h高度
    return itemWidth *shop.h / shop.w;
}
-(CGFloat)RowMarginInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return 20;
}
-(CGFloat)ColumnCountInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return 3;
}
-(UIEdgeInsets)EdgeInsetsInWaterFallLayout:(ZBWaterFallLayout *)waterFallLayout{
    return UIEdgeInsetsMake(10, 20, 30, 100);
}






















@end
