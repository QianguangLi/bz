//
//  RefreshViewController.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^EndRefreshing)(NSError *error);
@interface RefreshViewController : BaseViewController

@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger pageCount;

@property (assign, nonatomic) BOOL delay;//延迟加载数据，后面手动去加载

@property (assign, nonatomic) BOOL isRequireRefreshFooter;//是否需要上拉加载
@property (assign, nonatomic) BOOL isRequireRefreshHeader;//是否需要下拉刷新

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing;

-(void)startHeardRefresh;

- (void)stopRefreshing;

- (void)showTipWithNoData:(BOOL)show;
//延迟加载时根据时机手动启动加载
- (void)startRequest;

/**
 注册cell

 @param identifer cell identifer
 */
- (void)registerCellForCellReuseIdentifier:(NSString *)identifer;

@end
