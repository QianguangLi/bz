//
//  OrderInfoSendCell.h
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单发货 发货 订单信息
 */
@interface OrderInfoSendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *note;

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderState;

@end
