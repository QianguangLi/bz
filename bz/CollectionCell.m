//
//  CollectionCell.m
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface CollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UIImageView *pImg;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithProductModel:(ProductModel *)model
{
    _pName.text = model.pName;
    [_pImg setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _price.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    _time.text = model.favTime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
