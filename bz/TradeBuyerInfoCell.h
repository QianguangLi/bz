//
//  TradeBuyerInfoCell.h
//  bz
//
//  Created by qianchuang on 2017/3/13.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 交易订单 订单详情 买家信息cell
 */
@interface TradeBuyerInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memberId;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *memberNickName;
@property (weak, nonatomic) IBOutlet UILabel *conName;
@property (weak, nonatomic) IBOutlet UILabel *conPhone;
@property (weak, nonatomic) IBOutlet UILabel *memberEmail;
@property (weak, nonatomic) IBOutlet UILabel *conAddress;


@end
