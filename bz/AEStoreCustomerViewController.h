//
//  AEStoreCustomerViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/21.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StoreCustomerAdd,
    StoreCustomerEdit,
} StoreCustomerType;

/**
 添加客户  修改客户
 */
@interface AEStoreCustomerViewController : UITableViewController

@property (assign, nonatomic) StoreCustomerType type;

@end
