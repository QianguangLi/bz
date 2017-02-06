//
//  ConfirmOrderViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RefreshViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
 确认订单
 */
@interface ConfirmOrderViewController : RefreshViewController

@property (assign, nonatomic) BOOL isBuy;//立即购买
@property (strong, nonatomic) NSArray *shopppingCartArray;//购物车里面的卖家和商品

@end
