//
//  RechargeScanCell.h
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"
/**
 充值浏览cell
 */
@interface RechargeScanCell : UITableViewCell

- (void)setContentWithRechargeModel:(RechargeModel *)model;

@end
