//
//  OrderListBottomCell.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "OrderListBottomCell.h"
#import "UIView+Addition.m"
#import "OrderModel.h"

@interface OrderListBottomCell ()
{
    NSInteger _section;
    OrderModel *_orderModel;
}

//待付款按钮
@property (weak, nonatomic) IBOutlet UIButton *otherPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//待发货按钮
@property (weak, nonatomic) IBOutlet UIButton *returnGoodsBtn;

@end

@implementation OrderListBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_otherPayBtn setBorderCorneRadius:5];
    [_payBtn setBorderCorneRadius:5];
    [_cancelBtn setBorderCorneRadius:5];
    
    [_returnGoodsBtn setBorderCorneRadius:5];
}

- (void)setContentWithOrderModel:(OrderModel *)orderModel andSection:(NSInteger)section
{
    _orderTime.text = [NSString stringWithFormat:@"%@    ,", orderModel.orderTime];
    _section = section;
    _orderModel = orderModel;
    
    switch (orderModel.payStatus) {
        case OrderTypeWaitPay:
        {
            _waitPayView.hidden = NO;
            _waitPostView.hidden = YES;
        }
            break;
        case OrderTypeWaitPost:
        {
            _waitPostView.hidden = NO;
            _waitPayView.hidden = YES;
        }
            break;
        case OrderTypeWaitRecive:
        {
            _waitPayView.hidden = YES;
            _waitPostView.hidden = YES;
        }
            break;
        case OrderTypeWaitComment:
        {
            _waitPayView.hidden = YES;
            _waitPostView.hidden = YES;
        }
            break;
        case OrderTypeInvalid:
        {
            _waitPayView.hidden = YES;
            _waitPostView.hidden = YES;
        }
            break;
        case OrderTypeSuccess:
        {
            _waitPayView.hidden = YES;
            _waitPostView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

//MARK:取消订单
- (IBAction)cancelOrder:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelOrder:atSection:)]) {
        [_delegate cancelOrder:_orderModel atSection:_section];
    }
}
//MARK:立即付款
- (IBAction)payOrder:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(payOrder:atSection:)]) {
        [_delegate payOrder:_orderModel atSection:_section];
    }
}
//MARK:找人代付
- (IBAction)otherPayOrder:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(otherPayOrder:atSection:)]) {
        [_delegate otherPayOrder:_orderModel atSection:_section];
    }
}
//MARK:退货
- (IBAction)returnGoods:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(returnOrder:atSection:)]) {
        [_delegate returnOrder:_orderModel atSection:_section];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
