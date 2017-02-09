//
//  ServiceTimeCell.m
//  bz
//
//  Created by qianchuang on 2017/2/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ServiceTimeCell.h"

@interface ServiceTimeCell ()
{
    NSIndexPath *_indexPath;
}
@end

@implementation ServiceTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _jbLabel.text = [dict objectForKey:@"jb"];
    _zkLabel.text = [dict objectForKey:@"zk"];
}

- (IBAction)editAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editRowAtIndexPath:)]) {
        [_delegate editRowAtIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
