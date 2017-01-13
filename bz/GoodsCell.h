//
//  GoodsCell.h
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;

@interface GoodsCell : UITableViewCell

- (void)setContentWithProductModel:(ProductModel *)model;

@end
