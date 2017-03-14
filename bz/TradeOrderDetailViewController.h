//
//  TradeOrderDetailViewController.h
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RefreshViewController.h"

/**
 交易订单详情
 */
@interface TradeOrderDetailViewController : RefreshViewController

@property (copy, nonatomic) NSString *orderId;

@property (strong, nonatomic) NSArray *goodsArray;

@end
