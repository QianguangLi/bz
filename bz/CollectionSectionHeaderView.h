//
//  CollectionSectionHeaderView.h
//  bz
//
//  Created by LQG on 2016/12/31.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsCategoryModel;

/**
 分类页面 collection section header
 */
@interface CollectionSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *seperateLine;

- (void)setContentWithGoodsCategoryModel:(GoodsCategoryModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
