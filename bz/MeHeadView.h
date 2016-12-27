//
//  MeHeadView.h
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我 页面 tableview header
 */
@protocol MeHeadViewDelegate <NSObject>

- (void)loginButtonAction;

/**
 我 页面的三个订单点击

 @param orderType 0我的订单 1代付订单 2常购清单
 */
- (void)orderButtonAction:(NSInteger)orderType;

@end

@interface MeHeadView : UIView

@property (assign, nonatomic) id<MeHeadViewDelegate> delegate;

@end
