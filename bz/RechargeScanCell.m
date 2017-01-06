//
//  RechargeScanCell.m
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RechargeScanCell.h"

@interface RechargeScanCell ()

@property (weak, nonatomic) IBOutlet UILabel *memberid;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTime;
@property (weak, nonatomic) IBOutlet UILabel *rechargeMoney;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;

@end

@implementation RechargeScanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithRechargeModel:(RechargeModel *)model
{
    _memberid.text = kLoginUserName;
    _rechargeTime.text = model.remitTime;
    _rechargeMoney.text = [NSString stringWithFormat:@"+%.2f", model.remitterSum];
    _payStatus.text = model.isPay ? Localized(@"已支付") : Localized(@"未支付");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
