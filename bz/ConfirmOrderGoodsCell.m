//
//  ConfirmOrderGoodsCell.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ConfirmOrderGoodsCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ConfirmOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithProductModel:(ProductModel *)model
{
    _goodsName.text = model.pName;
    [_goodsImage setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    _property.text = model.propertyd;
    _quantity.text = [NSString stringWithFormat:@"x%lu", (unsigned long)model.quantity];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
