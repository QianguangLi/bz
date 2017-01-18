//
//  ChooseGoodsPropertyViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

typedef NS_ENUM(NSInteger,EnterType){
    
    FirstEnterType = 0,
    SecondEnterType
};
/**
 选择商品属性
 */
@interface ChooseGoodsPropertyViewController : BaseViewController

@property (nonatomic,assign) EnterType enterType;

@property (strong, nonatomic) ProductModel *model;

@end
