//
//  OrderProductCell.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface OrderProductCell : UITableViewCell

- (void)setContentWithProductModel:(ProductModel *)productModel andIndexPath:(NSIndexPath *)indexPath;

@end
