//
//  ProductModel.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation PropertysModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation PropertyModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
