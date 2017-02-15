//
//  RepositoryCell.h
//  bz
//
//  Created by qianchuang on 2017/2/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepositoryCellDelegate <NSObject>
@optional
- (void)editRepositoryAtIndexPath:(NSIndexPath *)indexPath;
- (void)viewRepositoryLocationAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface RepositoryCell : UITableViewCell

@property (weak, nonatomic) id <RepositoryCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *repositoryName;
@property (weak, nonatomic) IBOutlet UILabel *shortName;
@property (weak, nonatomic) IBOutlet UILabel *repositoryAddress;

- (void)setContentWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath;

@end
