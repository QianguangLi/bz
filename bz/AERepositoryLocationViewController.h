//
//  AERepositoryLocationViewController.h
//  bz
//
//  Created by qianchuang on 2017/2/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    RepositoryLocationTypeAdd,
    RepositoryLocationTypeEdit,
} RepositoryLocationType;
/**
 添加库位  修改库位 编辑库位
 */
@interface AERepositoryLocationViewController : UITableViewController

@property (assign, nonatomic) RepositoryLocationType type;

@property (assign, nonatomic) NSDictionary *locationInfo;//库位信息

@end
