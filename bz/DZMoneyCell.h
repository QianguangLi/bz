//
//  DZMoneyCell.h
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZMoneyModel.h"

/**
 账户明细cell
 */
@interface DZMoneyCell : UITableViewCell

- (void)setContentWithDZMoneyModel:(DZMoneyModel *)model;

@end
