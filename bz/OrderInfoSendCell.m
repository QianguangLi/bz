//
//  OrderInfoSendCell.m
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "OrderInfoSendCell.h"
#import "UIView+Addition.h"

@implementation OrderInfoSendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_note setBorderCorneRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
