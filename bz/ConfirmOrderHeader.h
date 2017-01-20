//
//  ConfirmOrderHeader.h
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

@interface ConfirmOrderHeader : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImage;

- (void)setContentWithShoppingCartModel:(ShoppingCartModel *)model;

@end
