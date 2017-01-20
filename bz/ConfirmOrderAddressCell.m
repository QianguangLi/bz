//
//  ConfirmOrderAddressCell.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ConfirmOrderAddressCell.h"

@implementation ConfirmOrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithAddressModel:(ShoppingAddressModel *)model
{
    if (model) {
        _conName.text = [NSString stringWithFormat:@"收件人:%@", model.conName];
        _comMobile.text = model.conMobile;
        _conAllAddress.text = [NSString stringWithFormat:@"%@ %@ %@", model.conArea, model.conAddr, model.condetail];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
