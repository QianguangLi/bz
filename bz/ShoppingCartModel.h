//
//  ShoppingCartModel.h
//  bz
//
//  Created by qianchuang on 2017/1/12.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol ProductModel;

/**
 购物车 model
 */
@interface ShoppingCartModel : JSONModel

@property (copy, nonatomic) NSString *storename;//卖家名字
@property (assign, nonatomic) double totalMoney;//总价格

@property (strong, nonatomic) NSMutableArray<ProductModel> *products;//包含的商品

// 买手左侧按钮是否选中
@property (nonatomic,assign) BOOL buyerIsChoosed;

// 买手下面商品是否全部编辑状态
@property (nonatomic,assign) BOOL buyerIsEditing;

@end
