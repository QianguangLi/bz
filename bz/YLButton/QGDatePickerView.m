//
//  QGDatePickerView.m
//  QJ
//
//  Created by Qianchuang on 14-7-18.
//  Copyright (c) 2014年 QianChuang. All rights reserved.
//

#import "QGDatePickerView.h"

@implementation QGDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, kScreenWidth, 220);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (instancetype)initWithTrueFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initView
{
    _inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.frame = CGRectMake(10, 0, 80, 40);
    _cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_inputAccessoryView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.frame = CGRectMake(kScreenWidth - 110, 0, 80, 40);
    _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_inputAccessoryView addSubview:_confirmBtn];
    _inputAccessoryView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:_inputAccessoryView];
    
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 180)];
    _pickerView.datePickerMode = UIDatePickerModeDate;
    _pickerView.backgroundColor = [UIColor whiteColor];
    NSString *string = @"1900-01-01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _pickerView.minimumDate = [dateFormatter dateFromString:string];
    _pickerView.maximumDate = [NSDate date];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _pickerView.locale = locale;
    [self addSubview:_pickerView];
}

- (void)comfirmAction:(UIButton *)btn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_pickerView.date];
    if (_delegate && [_delegate respondsToSelector:@selector(dateDidSelectedTheDate:)]) {
        [_delegate dateDidSelectedTheDate:dateString];
    } else {
        _didSelectDayHandler(dateString);
    }
}

//- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
//    _didSelectDayHandler = didSelectDayHandler;
//}

- (void)cancleAction:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerCancled)]) {
        [_delegate datePickerCancled];
    } else {
        _cancleHander();
    }
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
