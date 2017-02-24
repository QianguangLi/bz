//
//  CustomerCell.m
//  bz
//
//  Created by qianchuang on 2017/2/24.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CustomerCell.h"

@interface CustomerCell ()
{
    NSIndexPath *_indexPath;
}
@end

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)editAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editCustomerAtIndexPath:)]) {
        [_delegate editCustomerAtIndexPath:_indexPath];
    }
}

- (IBAction)delAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCustomerAtIndexPath:)]) {
        [_delegate deleteCustomerAtIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
