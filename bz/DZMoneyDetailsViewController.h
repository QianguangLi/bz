//
//  DZMoneyDetailsViewController.h
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"
#import "DZMoneyModel.h"

/**
 账户明细详情
 */
@interface DZMoneyDetailsViewController : BaseViewController

@property (assign, nonatomic) double balanceMoney;//结余金额
@property (strong, nonatomic) DZMoneyModel *model;

@end
