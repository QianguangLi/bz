//
//  FunctionListViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/30.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "FunctionListViewController.h"
#import "MeCell.h"
#import "UpdateMemberInfoTableViewController.h"
#import "ShoppingAddressViewController.h"
#import "DZMoneyViewController.h"
#import "DZMoneyRechargeViewController.h"
#import "RechargeScanViewController.h"
#import "BonusTXViewController.h"
#import "BonusTXScanViewController.h"
#import "AccountSafeViewController.h"
#import "WriteEmailViewController.h"

@interface FunctionListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *functionTableView;
@property (strong, nonatomic) NSArray *functionArray;
@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initFunctionArray];
    _functionTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [_functionTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)initFunctionArray
{
    switch (_menu) {
        case MeMenuMemberInfo:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"会员信息修改"), Localized(@"会员收货地址"), Localized(@"会员账号安全"), nil];
        }
            break;
        case MeMenuAccountInfo:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"账户明细"), Localized(@"电子钱包充值"), Localized(@"充值浏览"), Localized(@"奖金提现"), Localized(@"奖金提现浏览"), nil];
        }
            break;
        case MeMenuEmail:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"写信"), Localized(@"收件箱"), Localized(@"发件箱"), Localized(@"废件箱"), nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell" forIndexPath:indexPath];
    [cell setContentWithText:_functionArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_menu == MeMenuMemberInfo) {
        switch (indexPath.row) {
            case 0:
            {
                //会员信息修改
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZStoryboard" bundle:nil];
                 UpdateMemberInfoTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdateMemberInfoTableViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                //会员收货地址
                ShoppingAddressViewController *vc = [[ShoppingAddressViewController alloc] init];
                vc.isRequireRefreshHeader = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //会员账号安全 修改密码
                AccountSafeViewController *vc = [[AccountSafeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (_menu == MeMenuAccountInfo) {
        switch (indexPath.row) {
            case 0:
            {
                //账户明细
                DZMoneyViewController *vc = [[DZMoneyViewController alloc] init];
                vc.isRequireRefreshFooter = YES;
                vc.isRequireRefreshHeader = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                //电子钱包充值
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZStoryboard" bundle:nil];
                DZMoneyRechargeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DZMoneyRechargeViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //充值浏览
                RechargeScanViewController *vc = [[RechargeScanViewController alloc] init];
                vc.isRequireRefreshFooter = YES;
                vc.isRequireRefreshHeader = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                //奖金提现申请
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZStoryboard" bundle:nil];
                BonusTXViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BonusTXViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                //奖金提现浏览
                BonusTXScanViewController *vc = [[BonusTXScanViewController alloc] init];
                vc.isRequireRefreshFooter = YES;
                vc.isRequireRefreshHeader = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (_menu == MeMenuEmail) {
        switch (indexPath.row) {
            case 0:
            {
                WriteEmailViewController *vc= [[WriteEmailViewController alloc] init];
                //TODO:暂定会员等级
//                vc.access = kUserLevel;
                vc.access = UserLevelMember;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
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
