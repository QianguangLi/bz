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
    NSUInteger num = _countTF.text.integerValue;
    if (num > 1) {
        num--;
    }
    _countTF.text = [NSString stringWithFormat:@"%lu", (unsigned long)num];
    if (_countDelegate && [_countDelegate respondsToSelector:@selector(numberOfBuyGoods:)]) {
        [_countDelegate numberOfBuyGoods:num];
    }
}

- (IBAction)plus:(UIButton *)sender
{
    NSUInteger num = _countTF.text.integerValue;
    num++;
    _countTF.text = [NSString stringWithFormat:@"%lu", (unsigned long)num];
    if (_countDelegate && [_countDelegate respondsToSelector:@selector(numberOfBuyGoods:)]) {
        [_countDelegate numberOfBuyGoods:num];
    }
}

@end
