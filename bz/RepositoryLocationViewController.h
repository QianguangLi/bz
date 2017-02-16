//
//  RepositoryLocationViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/15.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RefreshViewController.h"

/**
 查看库位
 */
@interface RepositoryLocationViewController : RefreshViewController

@property (copy, nonatomic) NSString *repositoryId;//仓库id

@property (strong, nonatomic) NSDictionary *repositoryInfo;//仓库信息

@end
