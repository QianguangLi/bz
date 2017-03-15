//
//  MyOrdersViewController.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "BaseViewController.h"

/**
 我的订单
 */
@interface MyOrdersViewController : BaseViewController

//设置订单类型，同事设置会显示对应类型的订单列表
@property (assign, nonatomic) OrderType orderType;
//订单来自哪里
@property (assign, nonatomic) OrderFrom orderFrom;

@end
