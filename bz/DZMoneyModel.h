//
//  DZMoneyModel.h
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 电子钱包model
 */
@interface DZMoneyModel : JSONModel

@property (copy, nonatomic) NSString *id;//对账单id
@property (copy, nonatomic) NSString *direction;//转入0  转出1
@property (copy, nonatomic) NSString *kmType;//科目类型
@property (copy, nonatomic) NSString *time;//发生时间
@property (assign, nonatomic) double money;//发生余额
@property (copy, nonatomic) NSString<Optional> *note;//备注

@end
