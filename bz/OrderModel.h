//
//  OrderModel.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ProductModel;

/**
 订单model
 */
@interface OrderModel : JSONModel

@property (copy, nonatomic) NSString *storename;//卖家名字
@property (copy, nonatomic) NSString *bagging;//包装费
@property (copy, nonatomic) NSString *orderId;//订单号
@property (copy, nonatomic) NSString *orderTime;//订单时间
@property (assign, nonatomic) NSInteger payStatus;//支付状态
@property (assign, nonatomic) double totalMoney;//总价格
@property (assign, nonatomic) double totalPv;//总积分

@property (strong, nonatomic) NSArray<ProductModel> *products;

@end
