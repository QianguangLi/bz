//
//  AlwaysBuyViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BaseViewController.h"

/**
 常购清单
 */
@interface AlwaysBuyViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger pageCount;

@property (assign, nonatomic) BOOL isRequireRefreshFooter;//是否需要上拉加载
@property (assign, nonatomic) BOOL isRequireRefreshHeader;//是否需要下拉刷新

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(AlwaysBuyViewController * __weak)weakSelf;

-(void)startHeardRefresh;

- (void)stopRefreshing;

- (void)showTipWithNoData:(BOOL)show;
@end
