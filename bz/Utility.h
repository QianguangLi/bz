//
//  Utility.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocationModel.h"

/**
 实用工具
 */
@interface Utility : NSObject

/**
 持久化地理位置信息

 @param model 用户地理信息模型
 */
+ (void)persistentUserLocationInformation:(UserLocationModel *)model;

/**
 获取用户地理位置信息
 */
+ (UserLocationModel *)getUserLocationInformation;

@end
