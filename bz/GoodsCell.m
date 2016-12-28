//
//  GoodsCell.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsCell.h"
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
    if (IS_IPHONE_5) {
        _goodsName.font = [UIFont systemFontOfSize:15];
        _goodsPrice.font = [UIFont systemFontOfSize:15];
        _marketPrice.font = [UIFont systemFontOfSize:10];
        _pv.font = [UIFont systemFontOfSize:10];
        _distriWay.font = [UIFont systemFontOfSize:10];
    } else if (IS_IPHONE_6) {
        _goodsName.font = [UIFont systemFontOfSize:17];
        _goodsPrice.font = [UIFont systemFontOfSize:17];
        _marketPrice.font = [UIFont systemFontOfSize:12];
        _pv.font = [UIFont systemFontOfSize:12];
        _distriWay.font = [UIFont systemFontOfSize:12];
    } else if (IS_IPHONE_6P) {
        _goodsName.font = [UIFont systemFontOfSize:19];
        _goodsPrice.font = [UIFont systemFontOfSize:19];
        _marketPrice.font = [UIFont systemFontOfSize:14];
        _pv.font = [UIFont systemFontOfSize:14];
        _distriWay.font = [UIFont systemFontOfSize:14];
    }
    [_marketPrice setStrikeLineText:_marketPrice.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
