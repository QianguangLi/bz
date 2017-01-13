//
//  GoodsCell.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsCell.h"
#import "UIView+Addition.h"
#import "ProductModel.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Addition.h"

@interface GoodsCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *pv;
@property (weak, nonatomic) IBOutlet UILabel *distriWay;


@end

@implementation GoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_marketPrice setStrikeLineText:_marketPrice.text];
}

- (void)setContentWithProductModel:(ProductModel *)model
{
    _goodsName.text = model.pName;
    [_goodsImage setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    [_marketPrice setStrikeLineText:[NSString stringWithFormat:@"￥%.2f  ", model.markprice]];
    _pv.text = [NSString stringWithFormat:@"积分:%.2f", model.pv];
    _distriWay.text = model.shipping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
