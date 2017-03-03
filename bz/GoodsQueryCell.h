//
//  GoodsQueryCell.h
//  bz
//
//  Created by qianchuang on 2017/3/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 商品查询cell
 */
@interface GoodsQueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb;//类别
@property (weak, nonatomic) IBOutlet UILabel *commodityName;//商品名
@property (weak, nonatomic) IBOutlet UIImageView *commodityPicture;//图片
@property (weak, nonatomic) IBOutlet UILabel *hyj;//商品商户价
@property (weak, nonatomic) IBOutlet UILabel *singleWeight;//重量
@property (weak, nonatomic) IBOutlet UILabel *attribute;//属性

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath;
@end
