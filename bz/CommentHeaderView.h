//
//  CommentHeaderView.h
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;

/**
 评论头
 */
@interface CommentHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *productInfo;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightLayout;

- (void)setContentWithCommentModel:(CommentModel *)model;

@end
