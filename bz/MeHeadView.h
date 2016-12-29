//
//  MeHeadView.h
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

/**
 我 页面 tableview header
 */
@protocol MeHeadViewDelegate <NSObject>

- (void)loginButtonAction;

/**
 我 页面的三个订单点击

 @param type 0我的订单 1代付订单 2常购清单
 */
- (void)orderButtonAction:(NSInteger)type;


@end

@interface MeHeadView : UIView

@property (assign, nonatomic) id<MeHeadViewDelegate> delegate;

- (void)setUserModel:(UserModel *)userModel;

@end
