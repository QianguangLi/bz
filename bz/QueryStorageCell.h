//
//  QueryStorageCell.h
//  bz
//
//  Created by qianchuang on 2017/2/28.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 库存查询cell
 */
@interface QueryStorageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wareHouseName;//仓库
@property (weak, nonatomic) IBOutlet UILabel *storeName;//库位
@property (weak, nonatomic) IBOutlet UILabel *stockin;//实际总入库
@property (weak, nonatomic) IBOutlet UILabel *stockout;//实际总出库
@property (weak, nonatomic) IBOutlet UILabel *stock;//实际库存
@property (weak, nonatomic) IBOutlet UILabel *customCommodityId;//商品编码
@property (weak, nonatomic) IBOutlet UILabel *commodityName;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *commodityPropertyDescribe;//商品属性
@property (weak, nonatomic) IBOutlet UILabel *commoditySellPrice;//市场价

- (void)setContentWithDict:(NSDictionary *)dict;

@end
