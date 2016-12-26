//
//  NetWorkingService.h
//  bz
//
//  Created by LQG on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
//typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void(^Complete)(id responseObject, NSError *error);

@interface NetService : NSObject

/**
 get请求

 @param urlString <#urlString description#>
 @param paramters <#paramters description#>
 @param complete <#complete description#>
 @return <#return value description#>
 */
+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)paramters complete:(Complete)complete;

/**
 post请求

 @param urlString <#urlString description#>
 @param parameters <#parameters description#>
 @param complete <#complete description#>
 @return <#return value description#>
 */
+ (NSURLSessionTask *)POST:(NSString *)urlString parameters:(id)parameters complete:(Complete)complete;

@end
