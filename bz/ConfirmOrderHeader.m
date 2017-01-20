//
//  ConfirmOrderHeader.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ConfirmOrderHeader.h"
#import "UIImageView+AFNetworking.h"

@implementation ConfirmOrderHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithShoppingCartModel:(ShoppingCartModel *)model
{
    _sellerName.text = model.storename;
    [_sellerImage setImageWithURL:model.storelogo placeholderImage:[UIImage imageNamed:@"member-head"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
