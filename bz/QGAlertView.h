//
//  QGAlertView.h
//  QJ
//
//  Created by Qianchuang on 14-7-23.
//  Copyright (c) 2014年 QianChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QGAlertView;

typedef void(^AlertViewClickBtnAtIndex)(QGAlertView *alertView, NSInteger buttonIndex);
/**
 *带Block的AlertView
 */
@interface QGAlertView : UIAlertView <UIAlertViewDelegate>
{
    AlertViewClickBtnAtIndex _alertViewClickBtnAtIndex;
}

- (void)showWithBlock:(AlertViewClickBtnAtIndex)alertViewClickBtnAtIndexBlock;

@end
