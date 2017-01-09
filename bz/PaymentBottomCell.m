//
//  PaymentBottomCell.m
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "PaymentBottomCell.h"

@interface PaymentBottomCell ()
{
    NSInteger _section;
}
@property (weak, nonatomic) IBOutlet UILabel *apply;
@property (weak, nonatomic) IBOutlet UILabel *applyTime;
@property (weak, nonatomic) IBOutlet UILabel *applyNote;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;


@end

@implementation PaymentBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _rejectButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rejectButton.layer.borderWidth = 0.5;
    
    _payButton.layer.borderColor = kPinkColor.CGColor;
    [_payButton setTitleColor:kPinkColor forState:UIControlStateNormal];
    _payButton.layer.borderWidth = 0.5;
}

- (void)setContentWithOrderModel:(OrderModel *)model andSection:(NSInteger)section
{
    _section = section;
    
    _apply.text = [NSString stringWithFormat:@"请求人:%@", model.apply];
    _applyTime.text = [NSString stringWithFormat:@"请求时间:%@", model.orderTime];
    _applyNote.text = [NSString stringWithFormat:@"请求人备注:%@", model.remark];
}

- (IBAction)rejectAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(rejectPaySection:)]) {
        [_delegate rejectPaySection:_section];
    }
}

- (IBAction)payAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(paySection:)]) {
        [_delegate paySection:_section];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
