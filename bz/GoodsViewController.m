//
//  GoodsViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCell.h"
#import "MJRefresh.h"

@interface GoodsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *goodsTableView;
@property (assign, nonatomic) BOOL isUp;

@end
//上次偏移量
static CGFloat previousOffsetY = 0.f;

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView
{
    _goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _goodsTableView.backgroundColor = [UIColor clearColor];
//    _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _goodsTableView.showsVerticalScrollIndicator = NO;
    _goodsTableView.delegate = self;
    _goodsTableView.dataSource = self;
//    _goodsTableView.contentInset = UIEdgeInsetsMake(2.5, 0, 2.5, 0);
    
    [self.view addSubview:_goodsTableView];
    [_goodsTableView registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellReuseIdentifier:@"GoodsCell"];
    
    _goodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"header refresh");
    }];
    _goodsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"footer refresh");
    }];
    
    [_goodsTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth*100.0/320.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - previousOffsetY > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            _goodsTableView.frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight);
        }];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if ((previousOffsetY - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
    {
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            _goodsTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        }];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark -
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
