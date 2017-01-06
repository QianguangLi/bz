//
//  BonusScanCell.m
//  bz
//
//  Created by qianchuang on 2017/1/5.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BonusScanCell.h"

@interface BonusScanCell ()

@property (weak, nonatomic) IBOutlet UILabel *bankAccount;
@property (weak, nonatomic) IBOutlet UILabel *bonusDate;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *status;


@end

@implementation BonusScanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContextWithBonusModel:(BonusModel *)model
{
    _bankAccount.text = model.bankcard;
    _bonusDate.text = model.withdrawTime;
    _money.text = [NSString stringWithFormat:@"%.2f", model.withdrawMoney];
    if ([model.isAuditing isEqualToString:@"0"]) {
        _status.text = Localized(@"未处理");
    } else if ([model.isAuditing isEqualToString:@"1"]) {
        _status.text = Localized(@"处理中");
    } else if ([model.isAuditing isEqualToString:@"2"]) {
        _status.text = Localized(@"已汇款");
    } else if ([model.isAuditing isEqualToString:@"3"]) {
        _status.text = Localized(@"卡号有误");
    } else if ([model.isAuditing isEqualToString:@"4"]) {
        _status.text = Localized(@"待审核");
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
