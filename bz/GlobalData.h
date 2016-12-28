//
//  GlobalData.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户全局登陆信息
 */
@interface GlobalData : NSObject

+ (GlobalData *)sharedGlobalData;

//登陆类型
@property (assign, nonatomic) NSInteger userLevel;
//是否登陆
@property (assign, nonatomic) BOOL isLogin;
//登录信息
@property (copy, nonatomic) NSString *userName;
//登陆token
@property (copy, nonatomic) NSString *token;
//网络状态
@property (assign, nonatomic) BOOL hasNet;

@end
