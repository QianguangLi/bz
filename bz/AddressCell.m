//
//  AddressCell.m
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *conName;
@property (weak, nonatomic) IBOutlet UILabel *comMobile;
@property (weak, nonatomic) IBOutlet UILabel *conAllAddress;
@property (weak, nonatomic) IBOutlet UIButton *isDefaultButton;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithShoppingAddressModel:(ShoppingAddressModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    _conName.text = model.conName;
    _comMobile.text = model.conMobile;
    _conAllAddress.text = [NSString stringWithFormat:@"%@ %@ %@", model.conArea, model.conAddr, model.condetail];
    _isDefaultButton.selected = model.isDefault;
}

- (IBAction)defaultBtnAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(setDefaultButtonAtIndexPath:)]) {
        [_delegate setDefaultButtonAtIndexPath:_indexPath];
    }
}

- (IBAction)editBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editButtonActionAtIndexPath:)]) {
        [_delegate editButtonActionAtIndexPath:_indexPath];
    }
}

- (IBAction)delBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteButtonActionAtIndexPath:)]) {
        [_delegate deleteButtonActionAtIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
