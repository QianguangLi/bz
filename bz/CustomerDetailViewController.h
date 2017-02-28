//
//  CustomerDetailViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/28.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"
@class CustomerModel;

/**
 客户详细信息
 */
@interface CustomerDetailViewController : BaseViewController
@property (strong, nonatomic) CustomerModel *customerModel;
@end
