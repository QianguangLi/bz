//
//  UIView+MyFont.m
//  bz
//
//  Created by qianchuang on 2017/1/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "UIView+MyFont.h"

//不同设备的屏幕比例(当然倍数可以自己控制)
#define SizeScale ((kScreenHeight > 568) ? kScreenHeight/568 : 1)

@implementation UIView (MyFont)

@end

@implementation UIFont (MyFont)

+(void)load{
    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    //然后交换类方法
    method_exchangeImplementations(newMethod, method);
    
//    //获取替换后的类方法
//    Method boldNewMethod = class_getClassMethod([self class], @selector(adjustBoldFont:));
//    //获取替换前的类方法
//    Method blodmethod = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));
//    //然后交换类方法
//    method_exchangeImplementations(boldNewMethod, blodmethod);
}

//+ (UIFont *)adjustBoldFont:(CGFloat)fontSize
//{
//    UIFont *newFont=nil;
//    if (IS_IPHONE_5){
//        newFont = [UIFont adjustBoldFont:fontSize - 2];
//    }else if (IS_IPHONE_6P){
//        newFont = [UIFont adjustBoldFont:fontSize + 2];
//    } else if (IS_IPHONE_4) {
//        newFont = [UIFont adjustBoldFont:fontSize-2];
//    } else {
//        newFont = [UIFont adjustBoldFont:fontSize];
//    }
//    return newFont;
//}

+ (UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont *newFont=nil;
    if (IS_IPHONE_5){
        newFont = [UIFont adjustFont:fontSize - 2];
    }else if (IS_IPHONE_6P){
        newFont = [UIFont adjustFont:fontSize + 2];
    } else if (IS_IPHONE_4) {
        newFont = [UIFont adjustFont:fontSize-2];
    } else {
        newFont = [UIFont adjustFont:fontSize];
    }
    return newFont;
}

@end

@implementation UIButton (MyFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 666){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
//            self.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        }
    }
    return self;
}

@end

@implementation UILabel (MyFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 666){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return self;
}

@end

@implementation UITextField (MyFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 666){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return self;
}

@end

@implementation UITextView (MyFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 666){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return self;
}

@end


