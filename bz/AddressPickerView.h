//
//  AddressPickerView.h
//  bz
//
//  Created by qianchuang on 2016/12/30.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressPickerViewDelegate <NSObject>
@optional
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid;

- (void)addressSelectedCountryName:(NSString *)countryName provinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName;

@end

@interface AddressPickerView : UIView

@property (assign, nonatomic) id<AddressPickerViewDelegate> delegate;

@property (assign, nonatomic) IBInspectable  NSUInteger numberOfTextField;
@property (strong, nonatomic) IBInspectable UIFont *textFont;
//根据areaid字符串设置默认显示的内容
- (void)setDefaultAddressWithAreaIDString:(NSString *)string;

@end
