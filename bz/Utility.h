//
//  Utility.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocationModel.h"
#import "MBProgressHUD.h"

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

/**
 显示MBProgressHUD
 */
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view;

/**
 隐藏MBProgressHUD
 */
+ (BOOL)hideHUDForView:(UIView *)view;

/**
 在也没上显示文字2秒钟
 */
+ (MBProgressHUD *)showString:(NSString *)string onView:(UIView *)view;

//判断是否是手机号
+ (BOOL) isLegalMobile:(NSString *)mobile;
//身份证验证方法
+ (BOOL)isLegalIDCardNumber:(NSString *)idCardNumber;
//email验证
+ (BOOL)isLegalEmail:(NSString *)email;
@end
