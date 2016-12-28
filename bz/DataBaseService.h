//
//  DataBaseService.h
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface DataBaseService : NSObject

+ (instancetype)sharedService;

//- (BOOL)openDataBase;

//- (BOOL)closeDataBase;

//- (BOOL)createAddressTable;

//- (BOOL)insertAddress:(Address *)address;
//从服务器请求地址信息，并储存到数据库
- (void)requestAddress;
//查询所有地址信息
- (void)selectAll;
//根据areaPid查询其下面的所有地址
- (NSArray<Address *> *)getAddressWithAreaPid:(NSString *)areaPid;
@end
