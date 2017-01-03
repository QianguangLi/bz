//
//  AddressCell.h
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingAddressModel.h"

@protocol AddressCellDelegate <NSObject>

- (void)editButtonActionAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteButtonActionAtIndexPath:(NSIndexPath *)indexPath;

- (void)setDefaultButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 收货地址cell
 */
@interface AddressCell : UITableViewCell

@property (weak, nonatomic) id<AddressCellDelegate> delegate;

- (void)setContentWithShoppingAddressModel:(ShoppingAddressModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
