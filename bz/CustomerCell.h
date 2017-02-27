//
//  CustomerCell.h
//  bz
//
//  Created by qianchuang on 2017/2/24.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerModel;

@protocol CustomerCellDelegate <NSObject>

@optional
- (void)editCustomerAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCustomerAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 门店客户 cell
 */
@interface CustomerCell : UITableViewCell

@property (weak, nonatomic) id <CustomerCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *face;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;

- (void)setContentWithCustomerModel:(CustomerModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
