//
//  EmailCell.m
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "EmailCell.h"

@interface EmailCell ()

@property (weak, nonatomic) IBOutlet UIButton *sender;
@property (weak, nonatomic) IBOutlet UILabel *sendDate;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation EmailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithEmailModel:(EmailModel *)model
{
    if (model.isRead) {
        [_sender setImage:nil forState:UIControlStateNormal];
    } else {
        [_sender setImage:[[UIImage imageNamed:@"dot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    [_sender setTitle:model.sender forState:UIControlStateNormal];
    _sendDate.text = model.sendDate;
    _content.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
