//
//  APServiceTimeViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    ServiceTimeTypeAdd,
    ServiceTimeTypeEdit,
} ServiceTimeType;

/**
 添加送达时间折扣  修改送达时间折扣
 */
@interface APServiceTimeViewController : BaseViewController

@property (assign, nonatomic) ServiceTimeType type;

@property (assign, nonatomic) NSDictionary *dict;

@end
