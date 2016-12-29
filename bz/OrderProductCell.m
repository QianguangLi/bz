//
//  OrderProductCell.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "OrderProductCell.h"
#import "UIImageView+AFNetworking.h"

@interface OrderProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pImage;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *property;
@property (weak, nonatomic) IBOutlet UILabel *quantity;


@end

@implementation OrderProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (IS_IPHONE_5) {
        _pName.font = [UIFont systemFontOfSize:15];
        _price.font = [UIFont systemFontOfSize:15];
        _property.font = [UIFont systemFontOfSize:15];
        _quantity.font = [UIFont systemFontOfSize:11];
    } else if (IS_IPHONE_6) {
        _pName.font = [UIFont systemFontOfSize:16];
        _price.font = [UIFont systemFontOfSize:16];
        _property.font = [UIFont systemFontOfSize:16];
        _quantity.font = [UIFont systemFontOfSize:12];
    } else if (IS_IPHONE_6P) {
        _pName.font = [UIFont systemFontOfSize:17];
        _price.font = [UIFont systemFontOfSize:17];
        _property.font = [UIFont systemFontOfSize:17];
        _quantity.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setContentWithProductModel:(ProductModel *)productModel
{
    //TODO:等待防止占位图片
    [_pImage setImageWithURL:[NSURL URLWithString:productModel.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _pName.text = productModel.pName;
    _property.text = productModel.propertyd;
    _price.text = [NSString stringWithFormat:@"%.2f", productModel.price];
    _quantity.text = [NSString stringWithFormat:@"x%lu", (long)productModel.quantity];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
