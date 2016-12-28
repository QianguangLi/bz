//
//  Address.h
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (assign, nonatomic) int ID;//id
@property (copy, nonatomic) NSString *areaId;//地区id
@property (copy, nonatomic) NSString *areaName;//地区名字
@property (assign, nonatomic) int level;//国 省 市 县
@property (assign, nonatomic) NSString *areaPid;//上级id

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
