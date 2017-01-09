//
//  PaymentBottomCell.h
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol PaymentBottomCellDelegate <NSObject>
@optional
- (void)rejectPaySection:(NSInteger)section;
- (void)paySection:(NSInteger)section;

@end

/**
 代付订单底部cell
 */
@interface PaymentBottomCell : UITableViewCell

@property (weak, nonatomic) id<PaymentBottomCellDelegate> delegate;

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section;

@end
