//
//  QGDatePickerView.h
//  QJ
//
//  Created by Qianchuang on 14-7-18.
//  Copyright (c) 2014年 QianChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSString *dateString);
typedef void(^CancleHandler)();

@protocol QGDatePickerViewDelegate <NSObject>

- (void)dateDidSelectedTheDate:(NSString *)date;
- (void)datePickerCancled;
@end
/**
 *日期选择器--中国日历
 */
@interface QGDatePickerView : UIView
{
    UIView *_inputAccessoryView;
    UIButton *_cancleBtn;
    UIButton *_confirmBtn;
}

- (instancetype)initWithTrueFrame:(CGRect)frame;

@property (retain, nonatomic) UIDatePicker *pickerView;
@property (retain, nonatomic) UITextView *textView;
@property (assign, nonatomic) id <QGDatePickerViewDelegate> delegate;

@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler;
@property (nonatomic, copy) CancleHandler cancleHander;

@end
