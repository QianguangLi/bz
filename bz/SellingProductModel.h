//
//  SellingProductModel.h
//  bz
//
//  Created by qianchuang on 2017/2/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 上下架商品model
 */
@interface SellingProductModel : JSONModel
@property (copy, nonatomic) NSString *productId;//商品id
@property (copy, nonatomic) NSString *pName;//商品名字
@property (copy, nonatomic) NSString *price;//价格
@property (copy, nonatomic) NSString *pImgUrl;//图片
@property (assign, nonatomic) double pv;//积分
@property (assign, nonatomic) NSUInteger salesVolume;//销量
@property (copy, nonatomic) NSString *categoryName;//商品分类
@property (copy, nonatomic) NSString *propertyd;//商品属性
@end
