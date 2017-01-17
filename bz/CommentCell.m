//
//  CommentCell.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CommentCell.h"
#import "UIView+Addition.h"
#import "CommentModel.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_faceImageView setCorneRadius:_faceImageView.bounds.size.width/2];
}

- (void)setContentWithCommentModel:(CommentModel *)model
{
    [_faceImageView setImageWithURL:[NSURL URLWithString:model.faceUrl] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _nameLabel.text = model.member;
    _contentLabel.text = model.content;
    _commentDate.text = model.commentDate;
    _productInfo.text = model.pname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
