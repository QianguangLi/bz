//
//  NetWorkingService.m
//  bz
//
//  Created by LQG on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "NetService.h"
#import "AFNetworking.h"

@interface NetService ()
@end
static AFHTTPSessionManager *manager = nil;

@implementation NetService

+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)paramters complete:(Complete)complete
{
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    NSLog(@"get:%@", manager);
    urlString = [NSString stringWithFormat:@"%@/%@", kBaseUrl, urlString];
    NSURLSessionDataTask *task = [manager GET:urlString parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil, error);
    }];
    return task;
}

+ (NSURLSessionTask *)POST:(NSString *)urlString parameters:(id)parameters complete:(Complete)complete
{
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    NSLog(@"post%@", manager);
    urlString = [NSString stringWithFormat:@"%@/%@", kBaseUrl, urlString];
    NSURLSessionDataTask *task = [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil, error);
    }];
    return task;
}

@end
