//
//  DZMoneyCell.m
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "DZMoneyCell.h"
#import "NSDate+GFCalendar.h"

@interface DZMoneyCell ()

@property (weak, nonatomic) IBOutlet UILabel *weekDay;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *kmType;
@property (weak, nonatomic) IBOutlet UILabel *note;

@end

@implementation DZMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDZMoneyModel:(DZMoneyModel *)model
{
    if ([NSDate dateIsToday:model.time]) {
        _weekDay.text = Localized(@"今天");
        _dataLabel.text = [model.time substringWithRange:NSMakeRange(11, 5)];
    } else {
        NSString *str = nil;
        switch ([NSDate weekDayOfDateString:model.time]) {
            case 0:
                str = Localized(@"周日");
                break;
            case 1:
                str = Localized(@"周一");
                break;
            case 2:
                str = Localized(@"周二");
                break;
            case 3:
                str = Localized(@"周三");
                break;
            case 4:
                str = Localized(@"周四");
                break;
            case 5:
                str = Localized(@"周五");
                break;
            case 6:
                str = Localized(@"周六");
                break;
            default:
                break;
        }
        _weekDay.text = str;
        _dataLabel.text = [model.time substringWithRange:NSMakeRange(5, 5)];
    }
    if ([model.direction isEqualToString:@"0"]) {
        _money.text = [NSString stringWithFormat:@"+%.2f", model.money];
    } else {
        _money.text = [NSString stringWithFormat:@"-%.2f", model.money];
    }
    _kmType.text = model.kmType;
    _note.text = [NSString stringWithFormat:@"摘要:%@", model.note];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
