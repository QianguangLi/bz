//
//  SelectLocationView.h
//  bz
//
//  Created by qianchuang on 2017/1/13.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectLocationViewDelegate <NSObject>
@optional
- (void)selectLocation:(NSString *)areaName;

@end

/**
 选择定位地址
 */
@interface SelectLocationView : UIView

@property (weak, nonatomic) id<SelectLocationViewDelegate> delegate;

@end
