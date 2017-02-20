//
//  CollectionRefreshViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CollectionRefreshViewController.h"
#import "MJRefresh.h"

@interface CollectionRefreshViewController ()

@property (strong, nonatomic) UILabel *tipView;
@property (assign, nonatomic) BOOL isRefreshing;//是否正在刷新

@end

@implementation CollectionRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pageIndex = 0;
    _pageSize = 20;
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout];
    
    _mCollectionView.backgroundColor = QGCOLOR(238, 238, 239, 1);
    _mCollectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:_mCollectionView];
    
    _tipView = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 30)];
    _tipView.text = Localized(@"努力加载中...");
    _tipView.textColor = [UIColor lightGrayColor];
    _tipView.textAlignment = NSTextAlignmentCenter;
    _tipView.hidden = NO;
    [_mCollectionView addSubview:_tipView];
    
    [self setRefreshControl];
    if (!_delay) {//如果不延迟加载，就直接加载
        [self startRequest];
    }
}

- (void)endRefresh:(NSError *)error
{
    if (error && IS_NULL_ARRAY(self.dataArray)) {
        self.tipView.text = Localized(@"数据加载失败,请重新加载");
        self.tipView.hidden = NO;
    } else {
        self.tipView.hidden = YES;
    }
    self.isRefreshing = NO;
    [self stopRefreshing];
}

- (void)startRequest
{
    self.isRefreshing = YES;
    _tipView.text = Localized(@"努力加载中...");
    _tipView.hidden = NO;
    WS(weakSelf);
    [self requestDataListPullDown:YES andEndRefreshing:^(NSError *error) {
        [weakSelf endRefresh:error];
    }];
}

- (void)startHeardRefresh
{
    [self.mCollectionView.mj_header beginRefreshing];
}
- (void)setRefreshControl
{
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    //    _mTableView.tableFooterView = view;
    if (_isRequireRefreshHeader) {
        __weak CollectionRefreshViewController *weakSelf = self;
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.isRefreshing) {
                [weakSelf stopRefreshing];
                return ;
            }
            [weakSelf showTipWithNoData:NO];
            weakSelf.pageIndex = 0;
            
            weakSelf.isRefreshing = YES;
            [weakSelf requestDataListPullDown:YES andEndRefreshing:^(NSError *error) {
                [weakSelf endRefresh:error];
            }];
        }];
        
        //隐藏时间 隐藏状态
        mjHeader.lastUpdatedTimeLabel.hidden = YES;
        mjHeader.stateLabel.hidden = YES;
        
        self.mCollectionView.mj_header = mjHeader;
        
        //        [self startHeardRefresh];
    }
    if (_isRequireRefreshFooter) {
        __weak CollectionRefreshViewController *weakSelf = self;
        MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.isRefreshing) {
                [weakSelf stopRefreshing];
                return ;
            }
            if (weakSelf.pageIndex >= weakSelf.pageCount-1) {
                [Utility showString:Localized(@"已经是最后一页了！") onView:weakSelf.view];
                [weakSelf.mCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [weakSelf showTipWithNoData:NO];
            weakSelf.pageIndex++;
            
            weakSelf.isRefreshing = YES;
            [weakSelf requestDataListPullDown:NO andEndRefreshing:^(NSError *error) {
                [weakSelf endRefresh:error];
            }];
        }];
        
        self.mCollectionView.mj_footer = mjFooter;
    }
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    endRefreshing(nil);
}

- (void)stopRefreshing
{
    WS(weakSelf);
    if (_isRequireRefreshHeader) {
        [weakSelf.mCollectionView.mj_header endRefreshing];
    }
    if (_isRequireRefreshFooter) {
        [weakSelf.mCollectionView.mj_footer endRefreshing];
    }
}

- (void)showTipWithNoData:(BOOL)show
{
    //    WS(weakSelf);
    self.tipView.text = Localized(@"无数据");
    self.tipView.hidden = !show;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
