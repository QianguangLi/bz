//
//  RepositoryLocationCell.m
//  bz
//
//  Created by qianchuang on 2017/2/15.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryLocationCell.h"

@implementation RepositoryLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)editBtnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editRepositoryLocationAtIndexPath:)]) {
        [_delegate editRepositoryLocationAtIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
