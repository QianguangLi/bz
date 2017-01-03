//
//  AddShoppingAddressViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 添加收货地址
 */
@interface AddShoppingAddressViewController : UITableViewController
//是否是编辑地址
@property (assign, nonatomic) BOOL isEdit;

@property (copy, nonatomic) NSString *conId;//收货地址id

@end
