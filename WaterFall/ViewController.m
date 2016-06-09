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
#import "MJRefresh.h"
@interface ViewController ()<UICollectionViewDataSource,ZBWaterFallLayoutDelegate>
/** 所有的商品数据 */
@property(nonatomic,strong)NSMutableArray *shops;
@property(nonatomic,weak)UICollectionView *collectionView;
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
    // 1.布局
    [self setUpLayout];
    // 2.刷新
    [self setUpRefresh];
    
    }



-(void)setUpLayout{
    // 1.创建布局
    ZBWaterFallLayout *layout = [[ZBWaterFallLayout alloc] init];
    // 千万别忘记，否则模拟器空白一片,显示不出数据.
    layout.delegate = self;
    // 2.创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 3.注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBShopCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ZBShopId ];
    
    // 注意:图片的背景是collectionView不是当前控制器，所以设置背景应该用collectionView.backgroundColor
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;

}
-(void)setUpRefresh{

        // 下拉刷新
        self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewShops)];
        [self.collectionView.header beginRefreshing];

        // 上拉刷新
        self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreShops)];
        // 代码1和代码2固定搭配，缺一不可。必须知道。否则要么，不执行上拉刷新，要么下拉刷新时，有上拉刷新的提示
        self.collectionView.footer.hidden = YES; // 代码1

     }
/*
 *  下拉刷新（一定要移除掉之前的数据，把新的显示在用户眼前）
 */
-(void)LoadNewShops{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ZBShop objectArrayWithFilename:@"Clothes.plist"];
        // 移除数组中之前的数据，否则数组中的东西越来越多
        [self.shops removeAllObjects];
        // 添加新数据
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据（底层就会调用cellForItemAtIndexPath）
        [self.collectionView reloadData];
        // 停止刷新
        [self.collectionView.header endRefreshing];
    });
}
/*
 *  上拉刷新
 */
-(void)LoadMoreShops{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ZBShop objectArrayWithFilename:@"Clothes.plist"];
        [self.shops addObjectsFromArray:shops];
        // 刷新数据（底层就会调用cellForItemAtIndexPath）
        [self.collectionView reloadData];
        // 停止刷新
        [self.collectionView.footer endRefreshing];
        
    });
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    self.collectionView.footer.hidden = self.shops.count == 0;// 代码2
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
