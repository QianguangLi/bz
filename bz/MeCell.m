//
//  MeCell.m
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "MeCell.h"

@interface MeCell ()


@end

@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDict:(NSDictionary *)dict
{
    _titleLabel.text = dict[@"title"];
    _subTitleLabel.text = dict[@"subTitle"];
}

- (void)setContentWithText:(NSString *)text
{
    _titleLabel.text = text;
    _subTitleLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
