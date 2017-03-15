//
//  MyOrdersViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderListViewController.h"
#import "YLButton.h"

@interface MyOrdersViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *mPageViewController;
//二级导航
@property (weak, nonatomic) IBOutlet UIView *secondNavigation;
//控制器数组
@property (strong, nonatomic) NSMutableArray *controllerArray;
//记录上次选中状态的按钮
@property (strong, nonatomic) UIButton *previousButton;
//将要显示的订单类型
@property (assign, nonatomic) OrderType willShowOrderType;

@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _orderFrom==OrderFromMyOrder?Localized(@"我的订单"):Localized(@"在线订货订单");
    [self initNavigationBarItem];
    [self initSecondNavigation];
    [self initPageViewController];
}

- (void)initNavigationBarItem
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemAction:)];
    searchItem.tag = 200;
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(barItemAction:)];
    self.navigationItem.rightBarButtonItems = @[messageItem, searchItem];
    messageItem.tag = 201;
}

- (void)barItemAction:(UIBarButtonItem *)item
{
    if (item.tag == 200) {
        NSLog(@"search item touched!");
    } else if (item.tag) {
        NSLog(@"message item touched");
    }
}

- (void)initSecondNavigation
{
    //二级导航数据
    NSArray *contentArray = @[
  @{@"title":Localized(@"全部"), @"orderType": [NSNumber numberWithInteger:OrderTypeAll]},
  @{@"title":Localized(@"待付款"), @"orderType": [NSNumber numberWithInteger:OrderTypeWaitPay]},
  @{@"title":Localized(@"待发货"), @"orderType": [NSNumber numberWithInteger:OrderTypeWaitPost]},
  @{@"title":Localized(@"待收货"), @"orderType": [NSNumber numberWithInteger:OrderTypeWaitRecive]},
  @{@"title":Localized(@"待评价"), @"orderType": [NSNumber numberWithInteger:OrderTypeWaitComment]}
  ];
    //创建二级导航按钮
    for (int i = 0; i < contentArray.count; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth/contentArray.count * i, 0, kScreenWidth/contentArray.count, _secondNavigation.frame.size.height);
        [btn setTitle:contentArray[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTextRightImage:[UIImage imageNamed:@"more-red"] forState:UIControlStateSelected];
        //设置tag为订单类型
        btn.tag = [contentArray[i][@"orderType"] integerValue] + 100;
        [btn setTitleColor:kPinkColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(secondNavigationAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondNavigation addSubview:btn];
    }
}

- (void)secondNavigationAction:(UIButton *)btn
{
    //根据订单类型设置要显示的订单列表
    [self setControllerWithOrderType:btn.tag - 100];
}

- (void)initPageViewController
{
    //创建5种订单列表
    OrderListViewController *allOrdersVC = [[OrderListViewController alloc] init];
    allOrdersVC.orderType = OrderTypeAll;
    allOrdersVC.orderFrom = _orderFrom;
    allOrdersVC.isRequireRefreshFooter = YES;
    allOrdersVC.isRequireRefreshHeader = YES;
    OrderListViewController *waitPayVC = [[OrderListViewController alloc] init];
    waitPayVC.orderType = OrderTypeWaitPay;
    waitPayVC.orderFrom = _orderFrom;
    waitPayVC.isRequireRefreshFooter = YES;
    waitPayVC.isRequireRefreshHeader = YES;
    OrderListViewController *waitPostVC = [[OrderListViewController alloc] init];
    waitPostVC.orderType = OrderTypeWaitPost;
    waitPostVC.orderFrom = _orderFrom;
    waitPostVC.isRequireRefreshFooter = YES;
    waitPostVC.isRequireRefreshHeader = YES;
    OrderListViewController *waitReciveVC = [[OrderListViewController alloc] init];
    waitReciveVC.orderType = OrderTypeWaitRecive;
    waitReciveVC.orderFrom = _orderFrom;
    waitReciveVC.isRequireRefreshFooter = YES;
    waitReciveVC.isRequireRefreshHeader = YES;
    OrderListViewController *waitCommentVC = [[OrderListViewController alloc] init];
    waitCommentVC.orderType = OrderTypeWaitComment;
    waitCommentVC.orderFrom = _orderFrom;
    waitCommentVC.isRequireRefreshFooter = YES;
    waitCommentVC.isRequireRefreshHeader = YES;

    _controllerArray = [NSMutableArray arrayWithObjects:allOrdersVC, waitPayVC, waitPostVC, waitReciveVC, waitCommentVC, nil];
    
    //订单列表控制器
    _mPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _mPageViewController.delegate = self;
    _mPageViewController.dataSource = self;
    
    [self addChildViewController:_mPageViewController];
    [self.view addSubview:_mPageViewController.view];
    //调整子控制器大小
    _mPageViewController.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), 108, self.view.frame.size.width, self.view.frame.size.height - 108);
    [_mPageViewController didMoveToParentViewController:self];
    //初始化默认的订单类型设置订单列表
    [self setControllerWithOrderType:_orderType];
}

- (void)setControllerWithOrderType:(OrderType)orderType
{
    UIViewController *controller = nil;
    //查找对应订单类型的订单列表
    for (OrderListViewController *vc in _controllerArray) {
        if (vc.orderType == orderType) {
            controller = vc;
        }
    }
    //设置二级导航颜色
    [self setSecondNavigationColorWithOrderType:orderType];
//    __block MyOrdersViewController *weakSelf = self;
    //设置方向
    UIPageViewControllerNavigationDirection direction = orderType>_orderType ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    //点击后更新订单类型
    _orderType = orderType;
    //设置要显示的控制器
    [_mPageViewController setViewControllers:@[controller] direction:direction animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)setSecondNavigationColorWithOrderType:(OrderType)orderType
{
    //根据订单列表控制二级导航颜色 先取消上次的选中状态，再设置新的状态，并保存到_previousButton
    _previousButton.selected = NO;
    UIButton *btn = [_secondNavigation viewWithTag:orderType + 100];
    btn.selected = YES;
    _previousButton = btn;
}

#pragma mark - UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [_controllerArray indexOfObject:viewController];
    if (index == _controllerArray.count - 1) {
        return nil;
    } else {
        return _controllerArray[index + 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [_controllerArray indexOfObject:viewController];
    if (index == 0) {
        return nil;
    } else {
        return _controllerArray[index - 1];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    //获取将要出现的订单列表，保存到_willShowOrderType
    OrderListViewController *vc = (OrderListViewController *)pendingViewControllers[0];
    _willShowOrderType = vc.orderType;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        //已经到达新的页面，给新页面对应的二级导航设置颜色
        [self setSecondNavigationColorWithOrderType:_willShowOrderType];
    }
}

#pragma mark
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
