//
//  ProductModel.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/**
 商品模型
 */
@interface ProductModel : JSONModel

@property (copy, nonatomic) NSString *productId;//商品id
@property (copy, nonatomic) NSString *pName;//商品名字
@property (assign, nonatomic) float price;//价格
@property (copy, nonatomic) NSString *pImgUrl;//图片
@property (assign, nonatomic) double pv;//积分
@property (assign, nonatomic) NSUInteger quantity;//数量
@property (copy, nonatomic) NSString *propertyd;//尺寸

@end
