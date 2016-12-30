//
//  OrderListTopCell.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "OrderListTopCell.h"

@interface OrderListTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderid;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;


@end

@implementation OrderListTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithOrderModel:(OrderModel *)orderModel
{
    _orderid.text = orderModel.storename;
    switch (orderModel.payStatus) {
        case OrderTypeWaitPay:
        {
            _orderStatus.text = Localized(@"待付款");
        }
            break;
        case OrderTypeWaitPost:
        {
            _orderStatus.text = Localized(@"待发货");
        }
            break;
        case OrderTypeWaitRecive:
        {
            _orderStatus.text = Localized(@"待收货");
        }
            break;
        case OrderTypeWaitComment:
        {
            _orderStatus.text = Localized(@"待评论");
        }
            break;
        case OrderTypeInvalid:
        {
            _orderStatus.text = Localized(@"交易关闭");
        }
            break;
        case OrderTypeSuccess:
        {
            _orderStatus.text = Localized(@"交易完成");
        }
            break;

        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
