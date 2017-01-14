//
//  ProductInfoCell.m
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ProductInfoCell.h"
#import "YLButton.h"

@implementation ProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_stateBtn setTextRightImage:[UIImage imageNamed:@"right-more"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
