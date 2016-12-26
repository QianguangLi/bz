//
//  UIImage+Addition.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return image;
}

@end

@implementation UIView (Addition)

- (void)setCorneRadius:(CGFloat)cornerRadius
{
    CALayer *layer = self.layer;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
}

@end
