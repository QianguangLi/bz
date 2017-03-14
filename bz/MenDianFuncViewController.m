//
//  MenDianFuncViewController.m
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "MenDianFuncViewController.h"
#import "MeCell.h"
//交易管理
#import "OrderSendViewController.h"
#import "TradeOrderViewController.h"
#import "TradeCommentViewController.h"
//门店设置
#import "UpdateStoreViewController.h"
#import "UpdateStoreLocationViewController.h"
#import "ServiceTimeViewController.h"
//库存管理
#import "RepositoryListViewController.h"
#import "StoreSellingViewController.h"
#import "QueryStorageViewController.h"
//商品查询
#import "GoodsQueryViewController.h"
#import "OrderOnlineViewController.h"
//门店客户
#import "AEStoreCustomerViewController.h"
#import "CustomerListViewController.h"

@interface MenDianFuncViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *functionTableView;
@property (strong, nonatomic) NSArray *functionArray;

@end

@implementation MenDianFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (_menu) {
        case StoreMenuDealManager:
            self.title = Localized(@"交易管理");
            break;
        case StoreMenuSetting:
            self.title = Localized(@"门店设置");
            break;
        case StoreMenuStockManager:
            self.title = Localized(@"库存管理");
            break;
        case StoreMenuGoodsManager:
            self.title = Localized(@"商品管理");
            break;
        case StoreMenuCustomer:
            self.title = Localized(@"门店客户");
            break;
        case StoreMenuEmail:
            self.title = Localized(@"门店信件");
            break;
        case StoreMenuApply:
            self.title = Localized(@"申请供应商");
            break;
        default:
            break;
    }
    [self initFunctionArray];
    _functionTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [_functionTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
}

- (void)initFunctionArray
{
    switch (_menu) {
        case StoreMenuDealManager:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"抢单/附近订单"), Localized(@"订单发货"), Localized(@"送达订单"), Localized(@"交易订单"), Localized(@"交易评价"), Localized(@"审核退货单"), nil];
        }
            break;
        case StoreMenuSetting:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"送达时间折扣"), Localized(@"我的门店"), Localized(@"门店装修"), Localized(@"域名设置"), Localized(@"门店信息修改"), Localized(@"门店位置设置"), nil];
        }
            break;
        case StoreMenuStockManager:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"商品上下架"), Localized(@"库存查询"), Localized(@"仓库管理"), Localized(@"申请入库"), Localized(@"入库查询"), nil];
        }
            break;
        case StoreMenuGoodsManager:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"商品发布"), Localized(@"商品查询"), Localized(@"在线订货"), Localized(@"在线订货订单"), nil];
        }
            break;
        case StoreMenuCustomer:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"门店级别设置"), Localized(@"添加客户"), Localized(@"查询客户"), nil];
        }
            break;
        case StoreMenuEmail:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"写信件"), Localized(@"收件箱"), Localized(@"发件箱"), Localized(@"废件箱"), nil];
        }
            break;
        case StoreMenuApply:
        {
            NSLog(@"申请供应商");
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (_menu) {
        case StoreMenuDealManager:
            [self dealManger:indexPath];
            break;
        case StoreMenuSetting:
            [self storeMenuSetting:indexPath];
            break;
        case StoreMenuStockManager:
            [self stockManager:indexPath];
            break;
        case StoreMenuGoodsManager:
            [self goodsManager:indexPath];
            break;
        case StoreMenuCustomer:
            [self storeCustomer:indexPath];
            break;
        case StoreMenuEmail:
            
            break;
        case StoreMenuApply:
            
            break;
            
        default:
            break;
    }
}
#pragma mark - 交易管理
- (void)dealManger:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            //订单发货
             OrderSendViewController *vc = [[OrderSendViewController alloc] init];
            vc.isRequireRefreshFooter = YES;
            vc.isRequireRefreshHeader = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
            
            break;
        case 3:
        {
            //交易订单
            TradeOrderViewController *vc = [[TradeOrderViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            vc.isRequireRefreshFooter = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            //交易评价
            TradeCommentViewController *vc = [[TradeCommentViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
}
#pragma mark - 门店设置
- (void)storeMenuSetting:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ServiceTimeViewController *vc = [[ServiceTimeViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            //门店信息修改
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZ1Storyboard" bundle:nil];
            UpdateStoreViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdateStoreViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            //门店位置设置
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZ1Storyboard" bundle:nil];
            UpdateStoreLocationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdateStoreLocationViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 库存管理
- (void)stockManager:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //商品上下架
            StoreSellingViewController *vc = [[StoreSellingViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            vc.isRequireRefreshFooter = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            //库存查询
            QueryStorageViewController *vc = [[QueryStorageViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            vc.isRequireRefreshFooter = YES;
            vc.delay = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //仓库管理
            RepositoryListViewController *vc = [[RepositoryListViewController alloc] init];
            vc.isRequireRefreshFooter = YES;
            vc.isRequireRefreshHeader = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 商品管理
- (void)goodsManager:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            //商品查询
            GoodsQueryViewController *vc = [[GoodsQueryViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            vc.isRequireRefreshFooter = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //在线订货
            OrderOnlineViewController *vc = [[OrderOnlineViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 门店客户
- (void)storeCustomer:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        
            break;
        case 1:
        {
            //添加客户
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZ1Storyboard" bundle:nil];
            AEStoreCustomerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AEStoreCustomerViewController"];
            vc.type = StoreCustomerAdd;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            CustomerListViewController *vc = [[CustomerListViewController alloc] init];
            vc.isRequireRefreshHeader = YES;
            vc.isRequireRefreshFooter = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
