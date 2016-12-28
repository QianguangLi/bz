//
//  UserModel.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _accountName = dict[kAccountName];
        _addr = dict[kAddr];
        _address = dict[kAddress];
        _bankAccount = dict[kBankAccount];
        _bankName = dict[kBankName];
        _dzbalance = dict[kDZBalance];
        _email = dict[kEmail];
        _faceUrl = dict[kFaceUrl];
        _idCard = dict[kIDCard];
        _jfbalance = dict[kJFBalance];
        _jjbalance = dict[kJJBalance];
        _loginName = dict[kLoginName];
        _mobile = dict[kMobile];
        _name = dict[kName];
        _zipCode = dict[kZipCode];
    }
    return self;
}

@end
