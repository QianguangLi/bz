//
//  TradeOrderTopCell.m
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "TradeOrderTopCell.h"
#import "OrderModel.h"

@implementation TradeOrderTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section
{
    _orderId.text = [NSString stringWithFormat:@"订单号:%@", model.orderId];
    
    switch (model.payStatus) {
        case 0:
        {
            _orderStatus.text = Localized(@"未支付");
        }
            break;
        case 1:
        {
            _orderStatus.text = Localized(@"已支付");
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
