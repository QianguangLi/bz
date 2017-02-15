//
//  RepositoryCell.m
//  bz
//
//  Created by qianchuang on 2017/2/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryCell.h"

@interface RepositoryCell ()
{
    NSIndexPath *_indexPath;
}
@end

@implementation RepositoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)editBtnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editRepositoryAtIndexPath:)]) {
        [_delegate editRepositoryAtIndexPath:_indexPath];
    }
}

- (IBAction)scanBtnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewRepositoryLocationAtIndexPath:)]) {
        [_delegate viewRepositoryLocationAtIndexPath:_indexPath];
    }
}

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    _repositoryName.text = dict[@"whname"];
    _shortName.text = dict[@"whshorename"];
    _repositoryAddress.text = [NSString stringWithFormat:@"%@ %@", dict[@"whaddresshz"], dict[@"whaddress"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
