//
//  StoreSellingCell.m
//  bz
//
//  Created by qianchuang on 2017/2/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "StoreSellingCell.h"
#import "SellingProductModel.h"
#import "UIImageView+AFNetworking.h"

@implementation StoreSellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithSellingProductModel:(SellingProductModel *)model
{
    _categoryName.text = model.categoryName;
    [_pImg setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _pName.text = model.pName;
    _proterty.text = [NSString stringWithFormat:@"%@", model.propertyd];
    _price.text = [NSString stringWithFormat:@"价格:%@", model.price];
    _pv.text = [NSString stringWithFormat:@"积分:%@", model.productId];
    _sales.text = [NSString stringWithFormat:@"销量:%lu", (unsigned long)model.salesVolume];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedBtn.selected = selected;
    // Configure the view for the selected state
}

@end
