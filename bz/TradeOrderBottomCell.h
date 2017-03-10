//
//  TradeOrderBottomCell.h
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

/**
 交易订单 bottom cell
 */
@interface TradeOrderBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section;
@end
