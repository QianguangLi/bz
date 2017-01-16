//
//  GoodsViewController.h
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "RefreshViewController.h"
#import "GoodsCategoryModel.h"

/**
 商品页面
 */
@interface GoodsViewController : RefreshViewController

@property (strong, nonatomic) GoodsCategoryModel *model;

@property (copy, nonatomic) NSString *kw;

@property (assign, nonatomic) BOOL isFirstEntry;//第一次进入

@end
