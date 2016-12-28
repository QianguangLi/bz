//
//  UserModel.h
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (copy, nonatomic) NSString *accountName;//开户名
@property (copy, nonatomic) NSString *addr;//国家区域
@property (copy, nonatomic) NSString *address;//详细地址
@property (copy, nonatomic) NSString *bankAccount;//开户账号
@property (copy, nonatomic) NSString *bankName;//开户行名字
@property (copy, nonatomic) NSString *dzbalance;//电子账户余额
@property (copy, nonatomic) NSString *email;//电子邮箱
@property (copy, nonatomic) NSString *faceUrl;//用户头像地址
@property (copy, nonatomic) NSString *idCard;//身份证号
@property (copy, nonatomic) NSString *jfbalance;//积分账户余额
@property (copy, nonatomic) NSString *jjbalance;//奖金账户余额
@property (copy, nonatomic) NSString *loginName;//登陆名
@property (copy, nonatomic) NSString *mobile;//手机号
@property (copy, nonatomic) NSString *name;//公司名字
@property (copy, nonatomic) NSString *zipCode;//邮编

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
