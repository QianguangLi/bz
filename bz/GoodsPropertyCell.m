//
//  GoodsPropertyCell.m
//  bz
//
//  Created by qianchuang on 2017/1/18.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GoodsPropertyCell.h"
#import "UIView+Addition.h"

@implementation GoodsPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_countTF setBorderCorneRadius:0];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _bgView.backgroundColor = kPinkColor;
        _propertyLabel.textColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _propertyLabel.textColor = [UIColor blackColor];
    }
}

- (IBAction)minus:(UIButton *)sender
{
    int num = _countTF.text.intValue;
    if (num > 1) {
        num--;
    }
    _countTF.text = [NSString stringWithFormat:@"%d", num];
    if (_countDelegate && [_countDelegate respondsToSelector:@selector(numberOfBuyGoods:)]) {
        [_countDelegate numberOfBuyGoods:num];
    }
}

- (IBAction)plus:(UIButton *)sender
{
    int num = _countTF.text.intValue;
    num++;
    _countTF.text = [NSString stringWithFormat:@"%d", num];
    _countTF.text = [NSString stringWithFormat:@"%d", num];
    if (_countDelegate && [_countDelegate respondsToSelector:@selector(numberOfBuyGoods:)]) {
        [_countDelegate numberOfBuyGoods:num];
    }
}

@end
