//
//  NSObject+Addition.m
//  bz
//
//  Created by LQG on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "NSObject+Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSObject (Addition)

@end

@implementation NSString (md5)

- (NSString *)md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        // @"%02X" 加密出来的md5是大写, @"%02x" 加密出来的是小写
        [outputString appendFormat:@"%02X",outputBuffer[count]];
    }
    return outputString;
}

@end
