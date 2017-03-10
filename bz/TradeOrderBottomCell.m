//
//  TradeOrderBottomCell.m
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "TradeOrderBottomCell.h"
#import "OrderModel.h"

@interface TradeOrderBottomCell ()
{
    NSInteger _section;
}
@end

@implementation TradeOrderBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section
{
    _section = section;
    
    _totalMoney.text = [NSString stringWithFormat:@"总金额:%.2f", model.totalMoney];
}

- (IBAction)detailAction:(UIButton *)sender
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
