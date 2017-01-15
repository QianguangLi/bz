//
//  MeCell.h
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)setContentWithDict:(NSDictionary *)dict;

- (void)setContentWithText:(NSString *)text;

@end
