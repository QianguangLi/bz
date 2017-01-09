//
//  AddressPickerView.m
//  bz
//
//  Created by qianchuang on 2016/12/30.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "AddressPickerView.h"
#import "DataBaseService.h"
#import "IQKeyboardManager.h"

//输入框高度
#define kTextFieldHeight 30.f
//输入框间隔
#define kTextFieldSeperate 5.f

@interface AddressPickerView () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    DataBaseService *service;
}
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) NSMutableArray<Address*> *addressArray;

@property (copy, nonatomic) NSString *countryid;
@property (copy, nonatomic) NSString *provinceid;
@property (copy, nonatomic) NSString *cityid;
@property (copy, nonatomic) NSString *countyid;

@property (copy, nonatomic) NSString *countryName;
@property (copy, nonatomic) NSString *provinceName;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *countyName;


@end

@implementation AddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 241.5, frame.size.height);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        service = [DataBaseService sharedService];
        [self initTextFields];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    _numberOfTextField = 4;
    service = [DataBaseService sharedService];
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 241.5, self.frame.size.height);
    [self initTextFields];
}

- (void)setDefaultAddressWithAreaIDString:(NSString *)string
{
    if (IS_NULL_STRING(string)) {
        return;
    }
    NSArray *arr = [string componentsSeparatedByString:@","];
    for (int i = 0; i < arr.count; i++) {
        if (i == 0) {
            _countryid = arr[0];
        } else if (i == 1) {
            _provinceid = arr[1];
        } else if (i == 2) {
            _cityid = arr[2];
        } else {
            _countyid = arr[3];
        }
        Address *address = [service getAddressWithAreaID:arr[i]];
        UITextField *tf = (UITextField *)[self viewWithTag:100 + i];
        tf.text = address.areaName ? address.areaName : Localized(@"请选择");
    }
}

- (void)initTextFields
{
    for (int i = 0; i < _numberOfTextField; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(
                    kTextFieldSeperate*(i+1)+(self.frame.size.width-kTextFieldSeperate*(_numberOfTextField+1))/_numberOfTextField*i,
                    self.frame.size.height/2-kTextFieldHeight/2,
                    (self.frame.size.width-(kTextFieldSeperate*(_numberOfTextField+1)))/_numberOfTextField,
                    kTextFieldHeight)];
        UIImage *image = [UIImage imageNamed:@"more.gray"];
        tf.text = Localized(@"请选择");
        tf.font = [UIFont systemFontOfSize:10];
        tf.textAlignment = NSTextAlignmentRight;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.rightViewMode = UITextFieldViewModeAlways;
        tf.rightView = imageView;
        tf.tag = 100 + i;
        
        tf.delegate = self;
        
        [self addSubview:tf];
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 229)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    _currentTextField = textField;
    Address *address = [[Address alloc] init];
    address.areaName = Localized(@"请选择");
    _addressArray = [NSMutableArray arrayWithObject:address];
    [_addressArray addObjectsFromArray:[self loadAddress]];
    _currentTextField.inputView = pickerView;
    [pickerView selectRow:0 inComponent:0 animated:YES];
}

- (NSArray<Address *> *)loadAddress
{
    if (_currentTextField.tag == 100) {
        return [service getAddressWithAreaPid:nil withLevel:0];
    } else if (_currentTextField.tag == 101) {
        return [service getAddressWithAreaPid:_countryid withLevel:1];
    } else if (_currentTextField.tag == 102) {
        return [service getAddressWithAreaPid:_provinceid withLevel:2];
    } else if (_currentTextField.tag == 103) {
        return [service getAddressWithAreaPid:_cityid withLevel:3];
    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _addressArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (IS_NULL_ARRAY(_addressArray)) {
        return Localized(@"请选择");
    }
    Address *address = [_addressArray objectAtIndex:row];
    return address.areaName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (IS_NULL_ARRAY(_addressArray)) {
        return;
    }
    Address *address = [_addressArray objectAtIndex:row];
    if (_currentTextField.tag == 100) {
        _countryid = address.areaId;
        _countryName = address.areaName;
        _provinceid = nil;
        _provinceName = nil;
        _cityid = nil;
        _cityName = nil;
        _countyid = nil;
        _countyName = nil;
    } else if (_currentTextField.tag == 101) {
        _provinceid = address.areaId;
        _provinceName = address.areaName;
        _cityid = nil;
        _cityName = nil;
        _countyid = nil;
        _countyName = nil;
    } else if (_currentTextField.tag == 102) {
        _cityid = address.areaId;
        _cityName = address.areaName;
        _countyid = nil;
        _countyName = nil;
    } else if (_currentTextField.tag == 103) {
        _countyid = address.areaId;
        _countyName = address.areaName;
    }
    for (int i = (int)_currentTextField.tag + 1; i <= 103; i++) {
        UITextField *tf = [self viewWithTag:i];
        tf.text = Localized(@"请选择");
    }
    _currentTextField.text = address.areaName;
    if (_delegate && [_delegate respondsToSelector:@selector(addressSelectedCountry:province:city:county:)]) {
        [_delegate addressSelectedCountry:_countryid province:_provinceid city:_cityid county:_countyid];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(addressSelectedCountryName:provinceName:cityName:countyName:)]) {
        [_delegate addressSelectedCountryName:_countryName provinceName:_provinceName cityName:_cityName countyName:_countyName];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
