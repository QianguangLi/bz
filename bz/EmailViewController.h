//
//  EmailViewController.h
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RefreshViewController.h"

/**
 收件箱 发件箱 废件箱
 */
@interface EmailViewController : RefreshViewController

@property (copy, nonatomic) NSString *action;//收件箱(rec) 发件箱(send) 废件箱(drop)


@end
