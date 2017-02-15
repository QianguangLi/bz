//
//  RepositoryLocationCell.h
//  bz
//
//  Created by qianchuang on 2017/2/15.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepositoryLocationCellDelegate <NSObject>



@end

/**
 库位cell
 */
@interface RepositoryLocationCell : UITableViewCell

@property (weak, nonatomic) id <RepositoryLocationCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *shortName;

@end
