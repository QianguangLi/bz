//
//  QGAlertView.m
//  QJ
//
//  Created by Qianchuang on 14-7-23.
//  Copyright (c) 2014年 QianChuang. All rights reserved.
//

#import "QGAlertView.h"

@implementation QGAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (void)showWithBlock:(AlertViewClickBtnAtIndex)alertViewClickBtnAtIndexBlock
{
    _alertViewClickBtnAtIndex = alertViewClickBtnAtIndexBlock;
    self.delegate = self;
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    _alertViewClickBtnAtIndex(self, buttonIndex);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
