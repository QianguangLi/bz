//
//  OrderInfoDetailCell.h
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单发货 详细 订单信息
 */
@interface OrderInfoDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *note;

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *jfPay;
@property (weak, nonatomic) IBOutlet UILabel *sendType;

@end
