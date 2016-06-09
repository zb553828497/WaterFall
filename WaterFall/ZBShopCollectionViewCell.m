//
//  ZBShopCollectionViewCell.m
//  WaterFall
//
//  Created by zhangbin on 16/6/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBShopCollectionViewCell.h"
#import "ZBShop.h"
#import "UIImageView+WebCache.h"

@interface ZBShopCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ClothesImage;

@end

@implementation ZBShopCollectionViewCell

-(void)setShop:(ZBShop *)shop{
    // 1.衣服的图片
    [self.ClothesImage sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    // 2.衣服的价格
    self.PriceLabel.text = shop.price;
}

@end
