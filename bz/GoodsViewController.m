//
//  GoodsViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCell.h"
#import "NetService.h"
#import "ProductModel.h"
#import "YLButton.h"

@interface GoodsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@property (assign, nonatomic) BOOL isUp;
@property (weak, nonatomic) IBOutlet UIView *secondNavigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secNavTopLayout;

@end
//上次偏移量
static CGFloat previousOffsetY = 0.f;

@implementation GoodsViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"GoodsViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSecondNavigation];
    [self initView];
    
    [self.view bringSubviewToFront:self.secondNavigation];
}

- (void)initView
{
    self.mTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-64-44);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.contentInset = UIEdgeInsetsZero;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellReuseIdentifier:@"GoodsCell"];
}

- (void)initSecondNavigation
{
    //二级导航数据
    NSArray *contentArray = @[
                              @{@"title":Localized(@"价格")},
                              @{@"title":Localized(@"商品品牌")},
                              @{@"title":Localized(@"销售排行")},
                              @{@"title":Localized(@"筛选")},
                              ];
    //创建二级导航按钮
    for (int i = 0; i < contentArray.count; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth/contentArray.count * i, 0, kScreenWidth/contentArray.count, _secondNavigation.frame.size.height);
        [btn setTitle:contentArray[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:kPinkColor forState:UIControlStateSelected];
        [btn setTextRightImage:[UIImage imageNamed:@"more-gray"] forState:UIControlStateNormal];
        [btn setTextRightImage:[UIImage imageNamed:@"more-red"] forState:UIControlStateSelected];
        //设置tag为订单类型
        btn.tag = [contentArray[i][@"orderType"] integerValue] + 100;
        [btn addTarget:self action:@selector(secondNavigationAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondNavigation addSubview:btn];
    }
}

- (void)secondNavigationAction:(UIButton *)btn
{
    //根据订单类型设置要显示的订单列表
//    [self setControllerWithOrderType:btn.tag - 100];
}


- (void)setKw:(NSString *)kw
{
    _kw = kw;
    if (!IS_NULL_STRING(_kw)) {
        [self startRequest];
    }
}

- (void)setModel:(GoodsCategoryModel *)model
{
    _model = model;
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    [_task cancel];
    WS(weakSelf);
    if (IS_NULL_STRING(_kw)) {
        _kw = @"";
    }
    NSString *categoryId = IS_NULL_STRING(_model.categoryId) ? @"" : _model.categoryId;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                 StringFromNumber(weakSelf.pageSize), kPageSize,
                                 categoryId, @"categoryId",
                                 _kw, @"kw",
                                 nil];
    _task = [NetService POST:@"/api/Home/CategoryList" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            
            //商品字典
            NSDictionary *productInfo = dataDict[@"productInfo"];
            weakSelf.pageCount = [productInfo[kPageCount] integerValue];
            NSArray *listArray = productInfo[@"products"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in listArray) {
                ProductModel *model = [[ProductModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    [cell setContentWithProductModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;//kScreenWidth*100.0/320.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    WS(weakSelf);
    if (currentPostion - previousOffsetY > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        if (scrollView.contentSize.height <= kScreenHeight-44) {
            return;
        }
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, -20, kScreenWidth, kScreenHeight-44);
            weakSelf.secNavTopLayout.constant = -44;
            [weakSelf.view layoutIfNeeded];
        }];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if ((previousOffsetY - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
    {
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64-44);
            weakSelf.secNavTopLayout.constant = 0;
            [weakSelf.view layoutIfNeeded];
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
