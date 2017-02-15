//
//  RepositoryAddViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RepositoryTypeAdd,
    RepositoryTypeEdit,
} RepositoryType;

/**
 添加仓库 修改仓库
 */
@interface RepositoryAddViewController : UITableViewController

@property (assign, nonatomic) RepositoryType type;

@property (copy, nonatomic) NSString *repositoryId;//仓库id

@end
