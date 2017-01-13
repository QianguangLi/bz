//
//  RightCell.m
//  bz
//
//  Created by LQG on 2016/12/31.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "RightCell.h"
#import "UIImageView+AFNetworking.h"

@interface RightCell ()
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation RightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithGoodsCategoryModel:(GoodsCategoryModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (model) {
        _classLabel.text = model.categoryName;
        [_classImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"fenlei_women-dress"]];
    } else {
        _classLabel.text = @"";
        _classImageView.image = nil;
    }
}

@end
