//
//  EmailCell.h
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailModel.h"

/**
 email cell
 */
@interface EmailCell : UITableViewCell

- (void)setContentWithEmailModel:(EmailModel *)model;

@end
