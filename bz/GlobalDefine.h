//
//  GlobalDefine.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h
#import <Foundation/Foundation.h>

#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

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
#define kPinkColor QGCOLOR(227, 28, 118, 1)

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self

#define kLoginUserName [GlobalData sharedGlobalData].userName
#define kIsLogin [GlobalData sharedGlobalData].isLogin
#define kLoginToken [GlobalData sharedGlobalData].token
#define kHasNet [GlobalData sharedGlobalData].hasNet
#define kUserLevel [GlobalData sharedGlobalData].userLevel

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

//签名key
#define kSignKey @"BzApi161227"
//百度地图key
#define kBaiduMapKey @"2oniPq1HOAliSu1lUnk7iZQINbBq7Lhu"
//获取地址位置信息后的通知
#define kLocateUserSuccessNotification @"locate_user_success_notification"
//登陆成功后的通知
#define kLoginSuccessNotification @"login_success_notification"
//添加或更新收货地址成功通知
#define kAddOrUpdateShoppingAddressSuccess @"add_or_update_shopping_address_success"
//删除充值记录通知
#define kDeleteRechargeSuccessNotification @"recharge_delete_success"
//重新登录通知，token验证失败的情况下
#define kReLoginNotification @"go_re_login_notification"
//会员申请过门店后的通知
#define kRegistStoreNotification @"after_regist_store_notification"

#define kBaseUrl @"http://103.48.169.52/bzapi"
//登录URL
#define kUserLoginUrl @"api/User/Login"
//注册url
#define kUserRegistUrl @"api/User/Regeister"
//获取用户信息url
#define kGetMemberInfoUrl @"api/User/GetMemberInfo"
//获取我的订单url
#define kGetMyOrders @"api/User/MyOrders"
//修改会员资料url
#define kUpdateMember @"api/User/ModifyMember"
//获取收货地址url
#define kGetShoppingAddressUrl @"api/User/GetConsigneeAddress"
//添加或修改收货地址
#define kAddOrUpdateShoppingAddressUrl @"api/User/ManageConsigneeAddress"
//根据id获取收货地址
#define kGetAddressByIdUrl @"api/User/GetConAddressById"
//设置默认或者删除 收货地址url
#define kSetDefOrDelUrl @"api/User/SetDefAddrOrDel"
//获取账户信息url
#define kGetUserAccountUrl @"api/User/Account"
//电子钱包充值url
#define kUserRechargeUrl @"api/User/Recharge"
//充值浏览url
#define kUserRechargeScanUrl @"api/User/RechargeView"
//提现申请url
#define kBonusTXUrl @"api/User/Bonus"
//奖金提现浏览url
#define kBonusTXScanUrl @"api/User/BonusView"
//收藏商品URL
#define kMyCollectionUrl @"api/User/FavoritesCommodity"
//写邮件
#define kWriteEmailUrl @"api/User/WriteMessage"
//修改密码
#define kModifyPasswordUrl @"api/User/ModifyPassword"

//用户权限
typedef NS_ENUM(NSInteger, UserLevel) {
    UserLevelMember = 0,//会员
    UserLevelStore,//门店
    UserLevelCompany,//供应商
};
//订单类型
typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeAll = -1,//全部
    OrderTypeWaitPay,//待付款
    OrderTypeWaitPost,//待发货
    OrderTypeWaitRecive,//待收货
    OrderTypeWaitComment,//待评价
    OrderTypeInvalid,//已失效
    OrderTypeSuccess,//交易成功
};
//我页面功能菜单
typedef NS_ENUM(NSInteger, MeMenu) {
    MeMenuShoppingCart = 0,//我的购物车
    MeMenuMemberInfo,//会员信息
    MeMenuAccountInfo,//账户信息
    MeMenuCollectGoods,//收藏商品
    MeMenuEmail,//我的信件
    MeMenuMendian,//我的门店
    MeMenuHelpCenter,//帮助中心
};

//我页面功能菜单
typedef NS_ENUM(NSInteger, StoreMenu) {
    StoreMenuDealManager = 0,//交易管理
    StoreMenuSetting,//门店设置
    StoreMenuStockManager,//库存管理
    StoreMenuGoodsManager,//商品管理
    StoreMenuCustomer,//门店客户
    StoreMenuEmail,//门店信件
    StoreMenuApply,//申请供应商
};

//网络状态码
typedef NS_ENUM(NSInteger, NetStatus) {
    NetStatusSuccess = 00000,//请求成功
    NetStatusNotFound,//找不到接口
    NetStatusParameterAnomaly,//参数异常
    NetStatusOutOfDate,//接口过时
    NetStatusForbidden,//接口禁止调用
    NetStatusNetAnomaly,//网络异常
    NetStatusInterfaceAnomaly,//接口异常
    NetStatusVerifyAPIKeyFailed,//apiKey验证失败
    NetStatusMethodError,//请求方式错误
    NetStatusVerifyTokenFailed,//token验证失败
    
    NetStatusUserNameExist,//用户名已存在
    NetStatusPhoneExist,//电话已被注册
    NetStatusEmailExist,//邮箱已被注册
    NetStatusVerificationCodeError,//验证码错误
    NetStatusCardExist,//身份证已被注册
    
    NetStatusLoginForbidden = 00020,//禁止登陆
    NetStatusLoginFailed,//用户名或密码错误
    NetStatusLogout,//账户被注销
    NetStatusWaitActive,//账号待激活
    
    NetStatusTokenFailed = 00040,//  令牌验证失败(用户未登录)
    NetStatusFaceError,//  头像格式不正确
    NetStatusPicError,//  图片大小不正确
    NetStatusBase64Error,//  无效的Base64值

    NetStatusAddressExist = 00050,//  收货地址已存在
    
    NetStatusOrderRepeatDelete = 00060,//  请不要重复删除订单
    NetStatusForbiddenDelete,//  已支付的订单无法删除
    
    NetStatusCancelCollect = 00070,//  已取消收藏
    
    NetStatusEmailEmpty = 80,//  邮件标题或内容为空
    
    NetStatusEmailRepeatDelete = 90,//  请不要重复删除
    NetStatusEmialNoDelete,//  邮件未删除
    NetStatusInvalidAction,//  无效的动作
    
    NetStatusOriginalPwdError = 00160,//  原始密码不正确
};

//字段定义
#define kAccountName @"accountName" //开户名
#define kAddr @"addr" //国家区域
#define kAddress @"address"  //详细地址
#define kBankAccount @"bankAccount"  //开户账号
#define kBankName @"bankName"  //开户行名字
#define kDZBalance @"dzbalance"  //电子账户余额
#define kEmail @"email"  //电子邮箱
#define kFaceUrl @"faceUrl" //用户头像地址
#define kIDCard @"idCard"  //身份证号
#define kJFBalance @"jfbalance" //积分账户余额
#define kJJBalance @"jjbalance" //奖金账户余额
#define kLoginName @"loginName" //登陆名
#define kMobile @"mobile" //手机号
#define kName @"name" //公司名字
#define kZipCode @"zipCode" //邮编

#define kPageIndex @"pageIndex" //第几页
#define kPageSize @"pageSize" //每页大小
#define kPageCount @"pageCount" //总页数

#endif /* GlobalDefine_h */
