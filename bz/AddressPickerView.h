//
//  AddressPickerView.h
//  bz
//
//  Created by qianchuang on 2016/12/30.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressPickerViewDelegate <NSObject>

- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid;

@end

@interface AddressPickerView : UIView

@property (assign, nonatomic) id<AddressPickerViewDelegate> delegate;

@property (assign, nonatomic) IBInspectable  NSUInteger numberOfTextField;
@property (strong, nonatomic) IBInspectable UIFont *textFont;

@end
