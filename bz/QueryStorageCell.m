//
//  QueryStorageCell.m
//  bz
//
//  Created by qianchuang on 2017/2/28.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "QueryStorageCell.h"

@implementation QueryStorageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDict:(NSDictionary *)dict
{
    _commodityName.text = dict[@"CommodityName"];
    _commodityPropertyDescribe.text = dict[@"CommodityPropertyDescribe"];
    _commoditySellPrice.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"CommoditySellPrice"] floatValue]];
    _customCommodityId.text = dict[@"CustomCommodityId"];
    _storeName.text = dict[@"StoreName"];
    _wareHouseName.text = dict[@"WareHouseName"];
    _stock.text = [[dict objectForKey:@"stock"] stringValue];
    _stockin.text = [[dict objectForKey:@"stockin"] stringValue];
    _stockout.text = [[dict objectForKey:@"stockout"] stringValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
