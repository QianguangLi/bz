//
//  OrderListTopCell.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderListTopCell : UITableViewCell

- (void)setContentWithOrderModel:(OrderModel *)orderModel andSection:(NSInteger)section;

@end
