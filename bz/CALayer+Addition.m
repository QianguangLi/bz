//
//  CALayer+Addition.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CALayer+Addition.h"

@implementation CALayer (Addition)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
