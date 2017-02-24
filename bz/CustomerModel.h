//
//  CustomerModel.h
//  bz
//
//  Created by qianchuang on 2017/2/24.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 客户model
 */
@interface CustomerModel : JSONModel

@property (copy, nonatomic) NSString *id;//唯一标识
@property (copy, nonatomic) NSString *memberid;//商户编号
@property (copy, nonatomic) NSString *cname;//姓名
@property (copy, nonatomic) NSString *age;//年龄
@property (copy, nonatomic) NSString *photo;//客户头像
@property (copy, nonatomic) NSString *sex;//性别
@property (copy, nonatomic) NSString *birthday;//生日
@property (copy, nonatomic) NSString *sfz;//身份证
@property (copy, nonatomic) NSString *phone;//联系电话
@property (copy, nonatomic) NSString *mobileTele;//移动电话
@property (copy, nonatomic) NSString *qq;//
@property (copy, nonatomic) NSString *wx;//微信
@property (copy, nonatomic) NSString *wb;//微博
@property (copy, nonatomic) NSString *email;//
@property (copy, nonatomic) NSString *areacode;//地区编码
@property (copy, nonatomic) NSString *address;//详细地址
@property (copy, nonatomic) NSString *postolCode;//邮编
@property (copy, nonatomic) NSString *remark;//其他

@end
