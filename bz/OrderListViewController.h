//
//  OrderListViewController.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "RefreshViewController.h"

/**
 订单列表
 */
@interface OrderListViewController : RefreshViewController

@property (assign, nonatomic) OrderType orderType;//-1 全部 0 待支付 1 待发货 2 待收货 3 待评价 4 已失效 5 交易成功
@property (assign, nonatomic) OrderFrom orderFrom;//订单来自哪里
@end
