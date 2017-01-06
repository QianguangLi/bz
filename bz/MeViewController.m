//
//  MeViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeadView.h"
#import "MeCell.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "NetService.h"
#import "UserModel.h"
#import "MyOrdersViewController.h"
#import "FunctionListViewController.h"
#import "MyCollectionViewController.h"

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource, MeHeadViewDelegate, UIAlertViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) MeHeadView *headView;

@end

@implementation MeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //观察登陆成功后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginSuccessNotification object:nil];
//    self.navigationController.navigationBarHidden = YES;
    [self initData];
    [self customView];
    //判断是否登陆
    if (kIsLogin) {
        [self loginSuccess:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    view.backgroundColor = kPinkColor;
    
    _headView = [[MeHeadView alloc] init];
    _headView.delegate = self;
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    //保持上部分颜色一致
    [_mTableView addSubview:view];
    
    _mTableView.tableHeaderView = _headView;
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.showsVerticalScrollIndicator = NO;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    [self.view addSubview:_mTableView];
    [_mTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
 
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    _mTableView.tableFooterView = footerView;
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
    _dataArray = @[@{@"title":Localized(@"我的购物车"), @"subTitle":@""},
                   @{@"title":Localized(@"会员信息"), @"subTitle":Localized(@"会员信息修改等")},
                   @{@"title":Localized(@"账户信息"), @"subTitle":Localized(@"账户明细")},
                   @{@"title":Localized(@"收藏商品"), @"subTitle":@""},
                   @{@"title":Localized(@"我的信件"), @"subTitle":@""},
                   @{@"title":Localized(@"进入我的门店"), @"subTitle":@""},
                   @{@"title":Localized(@"帮助中心"), @"subTitle":@""}].mutableCopy;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell" forIndexPath:indexPath];
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell setContentWithDict:dict];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!kIsLogin) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"温馨提示") message:Localized(@"登陆后才可进行操作,是否去登陆") delegate:self  cancelButtonTitle:Localized(@"再看看") otherButtonTitles:Localized(@"去登陆"), nil];
        [av show];
        return;
    }
    //TODO:登陆后可进行的操作
    switch (indexPath.row) {
        case MeMenuShoppingCart:
        {
            appDelegate.rootController.selectedIndex = 2;
        }
            break;
        case MeMenuMemberInfo:
        {
            FunctionListViewController *vc = [[FunctionListViewController alloc] init];
            vc.menu = MeMenuMemberInfo;
            vc.title = Localized(@"会员信息");
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuAccountInfo:
        {
            FunctionListViewController *vc = [[FunctionListViewController alloc] init];
            vc.menu = MeMenuAccountInfo;
            vc.title = Localized(@"账户信息");
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuCollectGoods:
        {
            MyCollectionViewController *vc = [[MyCollectionViewController alloc] init];
            vc.isRequireRefreshFooter = YES;
            vc.isRequireRefreshHeader = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuEmail:
        {
            FunctionListViewController *vc = [[FunctionListViewController alloc] init];
            vc.menu = MeMenuEmail;
            vc.title = Localized(@"我的信件");
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MeMenuMendian:
        {
            
        }
            break;
        case MeMenuHelpCenter:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark MeHeadViewDelegate
- (void)loginButtonAction
{
    if (kIsLogin) {
        //如果登陆了 取消点击反应
        return;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNvc animated:YES completion:^{
        
    }];
}

- (void)orderButtonAction:(NSInteger)type
{
    if (!kIsLogin) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"温馨提示") message:Localized(@"登陆后才可进行操作,是否去登陆") delegate:self  cancelButtonTitle:Localized(@"再看看") otherButtonTitles:Localized(@"去登陆"), nil];
        [av show];
        return;
    }
    //TODO:页面 三个订单点击事件
//    NSLog(@"%ld", (long)type);
    if (type == 0) {
        MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc] init];
        //从我进去默认全部订单
        myOrderVC.orderType = OrderTypeAll;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loginButtonAction];
    }
}

- (void)loginSuccess:(NSNotification *)notify
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    __block MeViewController *weakSelf = self;
    [NetService GET:kGetMemberInfoUrl parameters:dict complete:^(id responseObject, NSError *error) {
//        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
//            UserModel *userModel = [[UserModel alloc] initWithDict:dataDict];
            UserModel *userModel = [[UserModel alloc] initWithDictionary:dataDict error:nil];
            [weakSelf.headView setUserModel:userModel];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:self.view];
        }
    }];
//    [Utility showHUDAddedTo:self.view forTask:task];
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
