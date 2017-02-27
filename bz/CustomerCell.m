//
//  CustomerCell.m
//  bz
//
//  Created by qianchuang on 2017/2/24.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CustomerCell.h"
#import "CustomerModel.h"
#import "UIImageView+AFNetworking.h"

@interface CustomerCell ()
{
    NSIndexPath *_indexPath;
}
@end

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)editAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editCustomerAtIndexPath:)]) {
        [_delegate editCustomerAtIndexPath:_indexPath];
    }
}

- (IBAction)delAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCustomerAtIndexPath:)]) {
        [_delegate deleteCustomerAtIndexPath:_indexPath];
    }
}

- (void)setContentWithCustomerModel:(CustomerModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    [_face setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _name.text = [NSString stringWithFormat:@"姓名：%@", model.cname];
    _phone.text = [NSString stringWithFormat:@"电话：%@", model.phone];
    _address.text = [NSString stringWithFormat:@"地址：%@", model.yaddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
