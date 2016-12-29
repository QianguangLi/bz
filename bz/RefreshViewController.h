//
//  RefreshViewController.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "BaseViewController.h"

@interface RefreshViewController : BaseViewController

@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger pageCount;

@property (assign, nonatomic) BOOL isRequireRefreshFooter;//是否需要上拉加载
@property (assign, nonatomic) BOOL isRequireRefreshHeader;//是否需要下拉刷新

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(RefreshViewController * __weak)weakSelf;

- (void)stopRefreshing;

- (void)showTipWithNoData:(BOOL)show;

@end
