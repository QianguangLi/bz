//
//  ContryProductCollectionViewCell.m
//  Taowaitao
//
//  Created by 宓珂璟 on 16/6/8.
//  Copyright © 2016年 walatao.com. All rights reserved.
//

#import "AlwaysBuyCell.h"
#import "UIImageView+AFNetworking.h"

@interface AlwaysBuyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToShppingCartButton;
@property (weak, nonatomic) IBOutlet UILabel *buyTimes;

@end

@implementation AlwaysBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithProductModel:(ProductModel *)model
{
    [_imageView setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _nameLabel.text = model.pName;
    _buyTimes.text = [NSString stringWithFormat:@"已购买%lu次", (unsigned long)model.quantity];
}

- (IBAction)addToShoppingCart:(UIButton *)sender
{
    
}


@end
