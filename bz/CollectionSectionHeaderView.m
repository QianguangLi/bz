//
//  CollectionSectionHeaderView.m
//  bz
//
//  Created by LQG on 2016/12/31.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "CollectionSectionHeaderView.h"
#import "GoodsCategoryModel.h"

@interface CollectionSectionHeaderView ()
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@end

@implementation CollectionSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithGoodsCategoryModel:(GoodsCategoryModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _categoryName.text = model.categoryName;
}

@end
