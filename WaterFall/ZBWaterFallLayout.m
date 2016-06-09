//
//  ZBWaterFallLayout.m
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBWaterFallLayout.h"


/** 默认的列数*/
// 不要写在类扩展里面，否则会报错
static const NSInteger ZBDefaultColumnCount = 3;// 改为1就变成了UITableView
/** 默认每一列之间的间距*/
static const NSInteger ZBDefaultColumnMargin = 10;
/** 默认每一行之间的间距*/
static const NSInteger ZBDefaultRowMargin = 10;
/** 距离屏幕边缘的间距*/
static const UIEdgeInsets ZBDefaultEdgeInsets = {10,10,10,10};

@interface ZBWaterFallLayout()
/** 存放所有列的当前高度 */
@property(nonatomic,strong)NSMutableArray *columnHeights;
/** 存放所有小格子的布局属性 */
@property(nonatomic,strong)NSMutableArray *attrsArray;
@end

@implementation ZBWaterFallLayout

-(NSMutableArray *)columnHeights{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
-(NSMutableArray *)attrsArray{
    if(_attrsArray == nil){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;

}

/**
 * 1.初始化
 */
-(void)prepareLayout{
    [super prepareLayout];
    // 清除以前计算的所有高度 (为什么)
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < ZBDefaultColumnCount; i++) {
        [self.columnHeights addObject:@(ZBDefaultEdgeInsets.top)];
    }
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 创建每一个小格子对应的布局属性    count为50. 0表示第0组，即1组.只能为0，否则报错
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for(NSInteger i = 0;i < count;i++){
    // 创建位置(第0组的第i个indexPath)
    NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:i inSection:0];
    // 获取indexPath位置上小格子(item)对应的布局属性.一共50个indexPath，所以attrsArray数组中一共装了50个小格子
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 2.决定小格子如何排列
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;

}
/**
 * 3.返回indexPath位置上的小格子对应的布局属性。即计算每一个小格子的位置就会调用，如果有50个小格子，那么就调用50次
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    // indexPath位置上的小格子的宽度 = (collectionView的宽度 - 左边缘 - 右边缘 - 中间的间距) / 列数
    CGFloat w = (collectionViewW - ZBDefaultEdgeInsets.left - ZBDefaultEdgeInsets.right - (ZBDefaultColumnCount - 1) * ZBDefaultColumnMargin )/ ZBDefaultColumnCount ;
     // indexPath位置上的小格子的高度
    CGFloat h = 50 + arc4random_uniform(100);//   50 < h的范围 < 150
    
    // 以下代码是找出高度最短的那一列
    // 假设先让第0列高度最短。目的:少遍历一次。遍历次数越少，说明优化的好嘛
    NSInteger ShortestColumn = 0;
    // 第0列的总高度=这一列中所有的小格子的总高度+这一列中所有小格子的间距
    CGFloat MinHeightAtColumn = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0; i < ZBDefaultColumnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        // 如果MinHeightAtColumn的高度大于第i列的高度，就把第i列的高度变为最小高度
        if (MinHeightAtColumn > columnHeight) {
            MinHeightAtColumn = columnHeight;
            // 记录最短列的下标
            ShortestColumn = i;
        }
    }
    // 计算indexPath位置上的小格子要显示在最短列时，小格子的x坐标
    // x = 左间距 + 高度最小的那一列的列号 * (小格子的宽度 + 列间距)
    CGFloat x = ZBDefaultEdgeInsets.left + ShortestColumn * (w + ZBDefaultColumnMargin);
    // 计算indexPath位置上的小格子要显示在最短列时，小格子的y坐标
    CGFloat y = MinHeightAtColumn;
    // 如果是y坐标不等于顶部间距10，那么说明这一行不是第0行，就让这一行的y坐标=行间距+这一行的y坐标。
    // 如果y坐标 = 顶部间距间距10，那么说明这一行是第0行，那么第0行的y坐标 = 10
    if (y != ZBDefaultEdgeInsets.top) {
        y+= ZBDefaultColumnMargin;
    }
    // indexPath位置上的小格子的frame
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新最短那列的高度(即把这个小格子添加到最短列中)
    self.columnHeights[ShortestColumn] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}

/**
 * 4.滚动的内容尺寸(通过for循环找出高度最高的那一列来决定滚动的范围)
 */
-(CGSize)collectionViewContentSize{
    CGFloat MaxHeightAtColumn = [self.columnHeights[0] doubleValue];
    // 找出高度最高的那一列。目的:确定滚动范围最高滚动到哪里。如果找高度最短的那一列，那么最高的那一列就滚动不到了。
    for (NSInteger i = 0; i < ZBDefaultColumnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if(MaxHeightAtColumn < columnHeight){
            MaxHeightAtColumn = columnHeight;
        }
    }
    // 滚动的宽度为0，滚动的高度为MaxHeightAtColumn + ZBDefaultEdgeInsets.bottom)
    return CGSizeMake(0, MaxHeightAtColumn + ZBDefaultEdgeInsets.bottom);

}

@end
