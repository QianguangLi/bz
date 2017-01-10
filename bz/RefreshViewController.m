//
//  RefreshViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "RefreshViewController.h"
#import "MJRefresh.h"

@interface RefreshViewController ()
{
    
}
@property (strong, nonatomic) UILabel *tipView;
@property (assign, nonatomic) BOOL isRefreshing;//是否正在刷新

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pageIndex = 0;
    _pageSize = 20;
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64) style:UITableViewStyleGrouped];
    _mTableView.sectionFooterHeight = 0;
    _mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    _mTableView.sectionHeaderHeight = 0;
    _mTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = QGCOLOR(238, 238, 239, 1);
    _mTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    _tipView = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 30)];
    _tipView.text = Localized(@"努力加载中...");
    _tipView.textColor = [UIColor lightGrayColor];
    _tipView.textAlignment = NSTextAlignmentCenter;
    _tipView.hidden = NO;
    [_mTableView addSubview:_tipView];
    
    self.isRefreshing = YES;
    WS(weakSelf);
    [self requestDataListPullDown:YES andEndRefreshing:^(NSError *error) {
        if (error && IS_NULL_ARRAY(weakSelf.dataArray)) {
            weakSelf.tipView.text = Localized(@"数据加载失败,请重新加载");
            weakSelf.tipView.hidden = NO;
        }
        weakSelf.isRefreshing = NO;
        [weakSelf stopRefreshing];
    }];
    [self setRefreshControl];
}

- (void)startHeardRefresh
{
    [self.mTableView.mj_header beginRefreshing];
}
- (void)setRefreshControl
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
//    _mTableView.tableFooterView = view;
    if (_isRequireRefreshHeader) {
        __weak RefreshViewController *weakSelf = self;
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.isRefreshing) {
                [weakSelf stopRefreshing];
                return ;
            }
            [weakSelf showTipWithNoData:NO];
            weakSelf.pageIndex = 0;
            
            weakSelf.isRefreshing = YES;
            [weakSelf requestDataListPullDown:YES andEndRefreshing:^(NSError *error) {
                if (error && IS_NULL_ARRAY(weakSelf.dataArray)) {
                    //如果出错并且数组为空，显示错误
                    weakSelf.tipView.text = Localized(@"数据加载失败,请重新加载");
                    weakSelf.tipView.hidden = NO;
                }

                weakSelf.isRefreshing = NO;
                [weakSelf stopRefreshing];
            }];
        }];

        self.mTableView.mj_header = mjHeader;
        
//        [self startHeardRefresh];
    }
    if (_isRequireRefreshFooter) {
        __weak RefreshViewController *weakSelf = self;
        MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.isRefreshing) {
                [weakSelf stopRefreshing];
                return ;
            }
            if (weakSelf.pageIndex >= weakSelf.pageCount-1) {
                [Utility showString:Localized(@"已经是最后一页了！") onView:weakSelf.view];
                [weakSelf.mTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [weakSelf showTipWithNoData:NO];
            weakSelf.pageIndex++;
            
            weakSelf.isRefreshing = YES;
            [weakSelf requestDataListPullDown:NO andEndRefreshing:^(NSError *error) {
                if (error && IS_NULL_ARRAY(weakSelf.dataArray)) {
                    //如果出错并且数组为空，显示错误
                    weakSelf.tipView.text = Localized(@"数据加载失败,请重新加载");
                    weakSelf.tipView.hidden = NO;
                }
                weakSelf.isRefreshing = NO;
                [weakSelf stopRefreshing];
            }];
        }];

        self.mTableView.mj_footer = mjFooter;
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
        [weakSelf.mTableView.mj_header endRefreshing];
    }
    if (_isRequireRefreshFooter) {
        [weakSelf.mTableView.mj_footer endRefreshing];
    }
}

- (void)showTipWithNoData:(BOOL)show
{
    WS(weakSelf);
    weakSelf.tipView.text = Localized(@"无数据");
    weakSelf.tipView.hidden = !show;
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
