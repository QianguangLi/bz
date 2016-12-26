//
//  GlobalData.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GlobalData.h"

__strong static GlobalData *singleton = nil;

@implementation GlobalData

+ (GlobalData *)sharedGlobalData
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedGlobalData];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
