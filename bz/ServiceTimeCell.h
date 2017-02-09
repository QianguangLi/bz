//
//  ServiceTimeCell.h
//  bz
//
//  Created by qianchuang on 2017/2/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceTimeCellDelegate <NSObject>

@optional
- (void)editRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 送达时间折扣cell
 */
@interface ServiceTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jbLabel;
@property (weak, nonatomic) IBOutlet UILabel *zkLabel;

@property (weak, nonatomic) id <ServiceTimeCellDelegate> delegate;

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath;

@end
