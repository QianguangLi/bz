//
//  OrderListBottomCell.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@protocol OrderListBottomCellDelegate <NSObject>

@optional
//找人代付
- (void)otherPayOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
//立即付款
- (void)payOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
//取消订单
- (void)cancelOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
//退货
- (void)returnOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
//确认收货
- (void)confirmOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
//给个评价
- (void)commentOrder:(OrderModel *)orderModel atSection:(NSInteger)section;
@end

@interface OrderListBottomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@property (weak, nonatomic) IBOutlet UIView *waitPayView;
@property (weak, nonatomic) IBOutlet UIView *waitPostView;
@property (weak, nonatomic) IBOutlet UIView *waitReciveView;
@property (weak, nonatomic) IBOutlet UIView *waitCommentView;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIView *invalidView;


@property (weak, nonatomic) id <OrderListBottomCellDelegate> delegate;

- (void)setContentWithOrderModel:(OrderModel *)orderModel andSection:(NSInteger)section;

@end
