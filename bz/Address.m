//
//  Address.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "Address.h"

@implementation Address

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _ID = [dict[@"id"] intValue];
        _areaId = dict[@"areaId"];
        _areaName = dict[@"areaName"];
        _level = [dict[@"level"] intValue];
        _areaPid = dict[@"areaPid"];
    }
    return self;
}

@end
