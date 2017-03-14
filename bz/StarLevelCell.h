//
//  StarLevelCell.h
//  bz
//
//  Created by qianchuang on 2017/3/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
/**
 星级cell
 */
@interface StarLevelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LCStarRatingView *startView1;
@property (weak, nonatomic) IBOutlet LCStarRatingView *startView2;
@property (weak, nonatomic) IBOutlet LCStarRatingView *startView3;
@property (weak, nonatomic) IBOutlet LCStarRatingView *startView4;
@property (weak, nonatomic) IBOutlet LCStarRatingView *startView5;

@end
