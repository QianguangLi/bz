//
//  CollectionCell.h
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

/**
 我的收藏商品cell
 */
@interface CollectionCell : UITableViewCell

- (void)setContentWithProductModel:(ProductModel *)model;

@end
