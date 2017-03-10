//
//  TradeOrderTopCell.h
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

/**
 交易订单顶部cell
 */
@interface TradeOrderTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section;

@end
