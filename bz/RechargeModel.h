//
//  RechargeModel.h
//  bz
//
//  Created by qianchuang on 2017/1/5.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RechargeModel : JSONModel

@property (copy, nonatomic) NSString *id;//充值id
@property (assign, nonatomic) BOOL isPay;//是否支付
@property (copy, nonatomic) NSString *remitTime;//充值时间
@property (copy, nonatomic) NSString *remitterSum;//充值金额
@property (copy, nonatomic) NSString<Optional> *note;//充值说明

@end
