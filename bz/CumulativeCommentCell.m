//
//  CumulativeCommentCell.m
//  bz
//
//  Created by qianchuang on 2017/3/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CumulativeCommentCell.h"

@implementation CumulativeCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth-20, 100) andColumnsWidths:[[NSArray alloc] initWithObjects:@((kScreenWidth-10)/6.0),@((kScreenWidth-10)/6.0),@((kScreenWidth-10)/6.0), @((kScreenWidth-10)/6.0), @((kScreenWidth-10)/6.0), @((kScreenWidth-10)/6.0), nil]];
    
    
    [_matrix addRecord:[[NSArray alloc] initWithObjects:@" ", @"最近1周  ", @"最近1个月 ", @"最近6个月 ", @"6个月前  ", @"总计 ", nil]];
//    [matrix addRecord:[[NSArray alloc] initWithObjects:@"好评", @"0", @"0", @"0", @"0", @"0", nil]];
//    [matrix addRecord:[[NSArray alloc] initWithObjects:@"中评", @"0", @"0", @"0", @"0", @"0", nil]];
//    [matrix addRecord:[[NSArray alloc] initWithObjects:@"差评", @"0", @"0", @"0", @"0", @"0", nil]];
//    [matrix addRecord:[[NSArray alloc] initWithObjects:@"总计", @"0", @"0", @"0", @"0", @"0", nil]];
    [self addSubview:_matrix];
//    NSLog(@"%@", NSStringFromCGRect(matrix.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
