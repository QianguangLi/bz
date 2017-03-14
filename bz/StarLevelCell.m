//
//  StarLevelCell.m
//  bz
//
//  Created by qianchuang on 2017/3/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "StarLevelCell.h"

@implementation StarLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _startView1.type = LCStarRatingViewCountingTypeHalfCutting;
    _startView2.type = LCStarRatingViewCountingTypeHalfCutting;
    _startView3.type = LCStarRatingViewCountingTypeHalfCutting;
    _startView4.type = LCStarRatingViewCountingTypeHalfCutting;
    _startView5.type = LCStarRatingViewCountingTypeHalfCutting;
    
    _startView1.starMargin = 5;
    _startView2.starMargin = 5;
    _startView3.starMargin = 5;
    _startView4.starMargin = 5;
    _startView5.starMargin = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
