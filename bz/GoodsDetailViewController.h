//
//  GoodsDetailViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"
@class ProductModel;

/**
 商品详情页面
 */
@interface GoodsDetailViewController : BaseViewController

@property (strong, nonatomic) ProductModel *productModel;//商品id

@end
