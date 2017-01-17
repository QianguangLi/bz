//
//  JXButton.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "JXButton.h"

@implementation JXButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageW = self.currentImage.size.width;
//    CGFloat imageH = contentRect.size.height * 0.7;
    CGFloat imageH = self.currentImage.size.height;
    return CGRectMake(contentRect.size.width/2-self.currentImage.size.width/2, contentRect.size.height *0.7/2-self.currentImage.size.height/2, imageW, imageH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
