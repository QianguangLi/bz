//
//  ShoppingAddressViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RefreshViewController.h"
@class ShoppingAddressViewController;
@class ShoppingAddressModel;

@protocol ShoppingAddressViewControllerDelegate <NSObject>
@optional
- (void)shoppingAddressViewController:(ShoppingAddressViewController *)vc didSelectedShoppingAddressModel:(ShoppingAddressModel *)model;

@end

/**
 会员收货地址
 */
@interface ShoppingAddressViewController : RefreshViewController

@property (weak, nonatomic) id <ShoppingAddressViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isSelect;//确认订单来选择地址

@end
