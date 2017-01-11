//
//  RightCell.h
//  bz
//
//  Created by LQG on 2016/12/31.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"

/**
 分类页面collection view cell
 */
@interface RightCell : UICollectionViewCell

- (void)setContentWithGoodsCategoryModel:(GoodsCategoryModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
