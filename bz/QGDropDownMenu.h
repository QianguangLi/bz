//
//  QGDropDownMenu.h
//  bz
//
//  Created by qianchuang on 2017/1/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QGDropDownMenu;
@protocol QGDropDownMenuDateSource <NSObject>

- (NSInteger)numberOfRowsDropDownMenu:(QGDropDownMenu *)dropDownMenu;
- (NSString *)dropDownMenu:(QGDropDownMenu *)dropDownMenu titleForRow:(NSInteger)row;
- (NSInteger)selectRowDropDownMenu:(QGDropDownMenu *)dropDownMenu;

@end

@protocol QGDropDownMenuDelegate <NSObject>

- (void)didRemoveForSuperViewDropDownMenu:(QGDropDownMenu *)dropDownMenu;
- (void)dropDownMenu:(QGDropDownMenu *)menu didSelectedRow:(NSInteger)row;

@end

@interface QGDropDownMenu : UIView

@property (weak, nonatomic) id <QGDropDownMenuDateSource> dateSource;
@property (weak, nonatomic) id <QGDropDownMenuDelegate> delegate;

- (void)reloadData;
- (instancetype)initWithOrigin:(CGPoint)origin andWidth:(CGFloat)width;

- (void)remove;

@end
