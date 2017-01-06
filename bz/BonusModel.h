//
//  BonusModel.h
//  bz
//
//  Created by qianchuang on 2017/1/5.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 奖金model
 */
@interface BonusModel : JSONModel

@property (copy, nonatomic) NSString *id;//提现id
@property (copy, nonatomic) NSString *isAuditing;//审核状态 审核状态( 0:未处理     1:处理中    2:已汇款    3:卡号有误    4:待审核)
@property (assign, nonatomic) double withdrawMoney;//提现金额
@property (copy, nonatomic) NSString *withdrawTime;//提现时间
@property (copy, nonatomic) NSString *bankcard;//银行卡号
@property (copy, nonatomic) NSString *bankname;//体现银行
@property (copy, nonatomic) NSString *kaihuName;//开户名
@property (copy, nonatomic) NSString<Optional> *note;//备注
@property (assign, nonatomic) double sxf;//手续费
@end
