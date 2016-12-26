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

@end
