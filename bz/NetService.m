//
//  NetWorkingService.m
//  bz
//
//  Created by LQG on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "NetService.h"
#import "AFNetworking.h"

//请求方式
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost,
};

@interface NetService ()
@end

@implementation NetService

+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)paramters complete:(Complete)complete
{
    return [self requestString:urlString useMethod:RequestMethodGet parameters:paramters complete:complete];
}

+ (NSURLSessionTask *)POST:(NSString *)urlString parameters:(id)parameters complete:(Complete)complete
{
    return [self requestString:urlString useMethod:RequestMethodPost parameters:parameters complete:complete];
}

+ (NSURLSessionTask *)requestString:(NSString *)urlString useMethod:(RequestMethod)method parameters:(id)parameters complete:(Complete)complete
{
    if (!kHasNet) {
        [Utility showString:Localized(@"无网状况不好,请检查网络连接。") onView:appDelegate.window];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:@{
                                                                                         NSLocalizedDescriptionKey:Localized(@"似乎已断开与互联网的连接。")}];
        complete(nil, error);
        return nil;
    }
    urlString = [NSString stringWithFormat:@"%@/%@", kBaseUrl, urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    //添加签名 签名：token+key, token没有传空，key=kSignKey ,用MD5加密
//    NSMutableDictionary *dict = (NSMutableDictionary *)parameters;
//    NSArray *arr = dict.allKeys;
    
    NSString *token = parameters[@"Token"];
    NSString *sign = token ? [[NSString stringWithFormat:@"%@%@",token, kSignKey] md5] : [kSignKey md5];
    [parameters setObject:sign forKey:@"Sign"];
    NSLog(@"URL:%@", urlString);
    NSLog(@"%@", parameters);
    if (method == RequestMethodGet) {
        return [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil, error);
        }];
    } else {
        return [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            complete(responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            complete(nil, error);
        }];
    }
}

@end