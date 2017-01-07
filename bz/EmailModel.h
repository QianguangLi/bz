//
//  EmailModel.h
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 email model
 */
@interface EmailModel : JSONModel

@property (copy, nonatomic) NSString *id;//标识id
@property (assign, nonatomic) UserLevel access;//该邮件属于哪个角色0会员 1门店
@property (copy, nonatomic) NSString *content;//邮件内容
@property (assign, nonatomic) BOOL isRead;//是否已读 0未读 1已读
@property (copy, nonatomic) NSString *receive;//收件人
@property (copy, nonatomic) NSString *sendDate;//发件时间
@property (copy, nonatomic) NSString *sender;//发件人
@property (copy, nonatomic) NSString *title;//邮件标题

@end
