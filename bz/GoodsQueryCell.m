//
//  GoodsQueryCell.m
//  bz
//
//  Created by qianchuang on 2017/3/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GoodsQueryCell.h"
#import "UIImageView+AFNetworking.h"

@implementation GoodsQueryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath
{
    _lb.text = [NSString stringWithFormat:@"%@", dict[@"lb"]];
    _commodityName.text = [NSString stringWithFormat:@"%@", dict[@"CommodityName"]];
    _hyj.text = [NSString stringWithFormat:@"商品商户价:%@", dict[@"hyj"]];
    _singleWeight.text = [NSString stringWithFormat:@"重量:%@", dict[@"singleWeight"]];
    _attribute.text = [NSString stringWithFormat:@"%@", dict[@"attribute"]];
    
    [_commodityPicture setImageWithURL:[NSURL URLWithString:dict[@"CommodityPicture"]] placeholderImage:[UIImage imageNamed:@"productpic"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
