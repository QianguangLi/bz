//
//  LeftCell.m
//  bz
//
//  Created by LQG on 2016/12/31.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "LeftCell.h"

@interface LeftCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation LeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithGoodsCategoryModel:(GoodsCategoryModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _categoryName.text = model.categoryName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
