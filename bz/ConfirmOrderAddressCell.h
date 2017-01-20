//
//  ConfirmOrderAddressCell.h
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingAddressModel.h"

/**
 确认订单 地址cell
 */
@interface ConfirmOrderAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *conName;
@property (weak, nonatomic) IBOutlet UILabel *comMobile;
@property (weak, nonatomic) IBOutlet UILabel *conAllAddress;

- (void)setContentWithAddressModel:(ShoppingAddressModel *)model;

@end
