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

@interface MeViewController () <UITableViewDelegate, UITableViewDataSource, MeHeadViewDelegate, UIAlertViewDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //观察登陆成功后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginSuccessNotification object:nil];
    self.navigationController.navigationBarHidden = YES;
    [self initData];
    [self customView];
}

- (void)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    view.backgroundColor = kPinkColor;
    
    MeHeadView *headView = [[MeHeadView alloc] init];
    headView.delegate = self;
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    //保持上部分颜色一致
    [_mTableView addSubview:view];
    
    _mTableView.tableHeaderView = headView;
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
    _dataArray = @[@{@"title":@"我的购物车", @"subTitle":@""},
                   @{@"title":@"会员信息", @"subTitle":@"会员信息修改等"},
                   @{@"title":@"账户信息", @"subTitle":@"账户明细"},
                   @{@"title":@"收藏商品", @"subTitle":@""},
                   @{@"title":@"我的信件", @"subTitle":@""},
                   @{@"title":@"进入我的门店", @"subTitle":@""},
                   @{@"title":@"帮助中心", @"subTitle":@""}].mutableCopy;
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
}

#pragma mark MeHeadViewDelegate
- (void)loginButtonAction
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNvc animated:YES completion:^{
        
    }];
}

- (void)orderButtonAction:(NSInteger)orderType
{
    //TODO:页面 三个订单点击事件
    NSLog(@"%ld", (long)orderType);
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
    NSLog(@"%@,%@", kLoginUserName, kLoginToken);
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
