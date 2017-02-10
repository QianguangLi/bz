//
//  ProductInfoCell.h
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLButton;

@interface ProductInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YLButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderId;

@end
