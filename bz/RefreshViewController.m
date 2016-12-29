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

@property (strong, nonatomic) UILabel *tipView;

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
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64) style:UITableViewStylePlain];
    
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = QGCOLOR(238, 238, 239, 1);
    _mTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    _tipView = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 30)];
    _tipView.text = Localized(@"无数据");
    _tipView.textColor = [UIColor lightGrayColor];
    _tipView.textAlignment = NSTextAlignmentCenter;
    _tipView.hidden = YES;
    [_mTableView addSubview:_tipView];
    
    [self setRefreshControl];
}

-(void)startHeardRefresh
{
    [self.mTableView.mj_header beginRefreshing];
}
- (void)setRefreshControl
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _mTableView.tableFooterView = view;
    if (_isRequireRefreshHeader) {
        __weak RefreshViewController *vc = self;
        self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self showTipWithNoData:NO];
            vc.pageIndex = 0;
            //            [vc.dataArray removeAllObjects];
            //            [vc.mTableView reloadData];
            [vc requestDataListPullDown:YES withWeakSelf:vc];
        }];
        
        [self startHeardRefresh];
    }
    if (_isRequireRefreshFooter) {
        __weak RefreshViewController *vc = self;
        self.mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (vc.pageIndex >= vc.pageCount-1) {
                [Utility showString:Localized(@"已经是最后一页了！") onView:vc.view];
                [vc.mTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self showTipWithNoData:NO];
            vc.pageIndex++;
            [vc requestDataListPullDown:NO withWeakSelf:vc];
        }];
    }
}

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(RefreshViewController *__weak)weakSelf
{
    
}

- (void)stopRefreshing
{
    if (_isRequireRefreshHeader) {
        [self.mTableView.mj_header endRefreshing];
    }
    if (_isRequireRefreshFooter) {
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)showTipWithNoData:(BOOL)show
{
    _tipView.hidden = !show;
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
