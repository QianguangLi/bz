
//
//  YLButton.m
//  YLButton
//
//  Created by HelloYeah on 2016/11/24.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLButton.h"

@interface YLButton ()
{
    BOOL isRightImage;
}

@end

@implementation YLButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

- (void)setImageRightWithFont:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(INTMAX_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    self.titleRect = CGRectMake(self.frame.size.width/2 - rect.size.width/2, 10, rect.size.width, rect.size.height);
    self.imageRect = CGRectMake(rect.size.width + self.frame.size.width/2 - rect.size.width/2, 15.5, 7.5, 7.5);
    
}

- (void)setRightImage:(UIImage *)image forState:(UIControlState)state
{
    isRightImage = YES;
    [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
    NSDictionary *dict = @{NSFontAttributeName:self.titleLabel.font};
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(INTMAX_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    self.titleRect = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height);
    //button 最右边图片
    self.imageRect = CGRectMake(self.frame.size.width-image.size.width-5, self.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height);
}

- (void)setTextRightImage:(UIImage *)image forState:(UIControlState)state
{
    isRightImage = NO;
    [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
    NSDictionary *dict = @{NSFontAttributeName:self.titleLabel.font};
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(INTMAX_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    self.titleRect = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height);
    //    今天文字靠右
    self.imageRect = CGRectMake(rect.size.width + self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if (isRightImage) {
        NSDictionary *dict = @{NSFontAttributeName:self.titleLabel.font};
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(INTMAX_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        self.titleRect = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height);
        //button 最右边图片
        self.imageRect = CGRectMake(self.frame.size.width-self.currentImage.size.width-5, self.frame.size.height/2 - self.currentImage.size.height/2, self.currentImage.size.width, self.currentImage.size.height);
    } else {
        NSDictionary *dict = @{NSFontAttributeName:self.titleLabel.font};
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(INTMAX_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        self.titleRect = CGRectMake(self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height);
        //    今天文字靠右
        self.imageRect = CGRectMake(rect.size.width + self.frame.size.width/2 - rect.size.width/2, self.frame.size.height/2 - self.currentImage.size.height/2, self.currentImage.size.width, self.currentImage.size.height);
    }
}

@end
