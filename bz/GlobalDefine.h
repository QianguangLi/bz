//
//  GlobalDefine.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#define appDelegate ([UIApplication sharedApplication].delegate)

#define IS_IOS_7 [[[UIDevice currentDevice] systemVersion] intValue] >= 7?YES:NO

#define IS_NULL_ARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0 )
#define IS_NULL(obj) (obj == nil || (NSObject *)obj == [NSNull null])
#define IS_NULL_STRING(str) (str == nil || (NSObject *)str == [NSNull null] || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)

#define Localized(str) NSLocalizedString(str, nil)

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE_4     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P    ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define QGCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kPinkColor QGCOLOR(225, 29, 118, 1)

#define kLoginUserName [GlobalData sharedGlobalData].userName
#define kIsLogin [GlobalData sharedGlobalData].isLogin
#define kLoginToken [GlobalData sharedGlobalData].token
#define kHasNet [GlobalData sharedGlobalData].hasNet

#define StringFromNumber(num) [NSString stringWithFormat:@"%ld", (long)num]
#define StringFromFloat(num) [NSString stringWithFormat:@"%.2f", num]

//系统版本判断宏
//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

//#endif

//文件，行，函数，info 宏定义
#undef  QGLog
#define QGLog(s,...) printf("<%s,Line:%d> info:%s\n",[[NSString stringWithUTF8String:__FILE__]lastPathComponent].UTF8String,__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__].UTF8String)

//百度地图key
#define kBaiduMapKey @"2oniPq1HOAliSu1lUnk7iZQINbBq7Lhu"
//获取地址位置信息后的通知
#define kLocateUserSuccessNotification @"locate_user_success_notification"

#define kBaseUrl @"http://103.48.169.52/BzApi"
//登录URL
#define kUserLoginUrl @"api/User/Login"

#endif /* GlobalDefine_h */
