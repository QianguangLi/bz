//
//  CommentHeaderView.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CommentHeaderView.h"
#import "CommentModel.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithCommentModel:(CommentModel *)model
{
    [_faceImageView setImageWithURL:[NSURL URLWithString:model.faceUrl] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _nameLabel.text = model.member;
    _contentLabel.text = model.content;
    _commentDate.text = model.commentDate;
    _productInfo.text = model.pname;
}

@end
