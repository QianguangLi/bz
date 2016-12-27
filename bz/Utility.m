//
//  Utility.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "Utility.h"

#define kUserLocationInfo @"user_location_info"

@implementation Utility

+ (void)persistentUserLocationInformation:(UserLocationModel *)model
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserLocationInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UserLocationModel *)getUserLocationInformation
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLocationInfo];
    if (!data) {
        return nil;
    }
    UserLocationModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = @"加载中...";
    hud.offset = CGPointMake(0, -32);
    hud.contentColor = [UIColor whiteColor];
    return hud;
}

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view forTask:(NSURLSessionTask *)task
{
    if (!task) {
        return nil;
    }
    return [self showHUDAddedTo:view];
}

+ (BOOL)hideHUDForView:(UIView *)view
{
    return [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (MBProgressHUD *)showString:(NSString *)string onView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0.f, -kScreenHeight/2.0/2.0);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
    return hud;
}

//判断是否是手机号
+ (BOOL)isLegalMobile:(NSString *)mobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^1[1-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//身份证验证方法
+ (BOOL)isLegalIDCardNumber:(NSString *)idCardNumber
{
    if (idCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCardNumber];
}

//email验证
+ (BOOL)isLegalEmail:(NSString *)email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:email];
}


@end
