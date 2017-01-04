//
//  DZMoneyModel.h
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DZMoneyModel : JSONModel

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *direction;
@property (copy, nonatomic) NSString *kmType;
@property (copy, nonatomic) NSString *time;
@property (assign, nonatomic) double money;
@property (copy, nonatomic) NSString<Optional> *note;

@end
