//
//  UIImage+Addition.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@interface UIView (Addition)
- (void)setCorneRadius:(CGFloat)cornerRadius;
- (void)setBorderCorneRadius:(CGFloat)cornerRadius;
@end

@interface UILabel (Addition)

- (void)setStrikeLineText:(NSString *)text;
- (CGFloat)heightInSize:(CGSize)size;
@end
