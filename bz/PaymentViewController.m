//
//  PaymentViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "PaymentViewController.h"
#import "NetService.h"
#import "OrderModel.h"
#import "OrderListTopCell.h"
#import "OrderProductCell.h"
#import "PaymentBottomCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "QGAlertView.h"

@interface PaymentViewController () <UITableViewDelegate, UITableViewDataSource, PaymentBottomCellDelegate>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_rejectTask;
}

@end

@implementation PaymentViewController

- (void)dealloc
{
    [_task cancel];
    [_rejectTask cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"代付订单");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderListTopCell" bundle:nil] forCellReuseIdentifier:@"OrderListTopCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderProductCell" bundle:nil] forCellReuseIdentifier:@"OrderProductCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"PaymentBottomCell" bundle:nil] forCellReuseIdentifier:@"PaymentBottomCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    WS(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                 StringFromNumber(weakSelf.pageSize), kPageSize,
                                 @"", @"orderid", nil];
    _task = [NetService POST:@"api/User/AnotherOrders" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *orderDict in listArray) {
                OrderModel *orderModel = [[OrderModel alloc] initWithDictionary:orderDict error:nil];
                [weakSelf.dataArray addObject:orderModel];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    
}

#pragma mark - PaymentBottomCellDelegate
//残忍拒绝代付
- (void)rejectPaySection:(NSInteger)section
{
    QGAlertView *av = [[QGAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确认要拒绝代付?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"确认"), nil];
    WS(weakSelf);
    [av showWithBlock:^(QGAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            OrderModel *model = weakSelf.dataArray[section];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         kLoginToken, @"Token",
                                         model.orderId, @"orderid", nil];
            _rejectTask = [NetService POST:@"api/User/DelAnotherOrders" parameters:dict complete:^(id responseObject, NSError *error) {
                [Utility hideHUDForView:weakSelf.view];
                if (error) {
                    NSLog(@"failure:%@", error);
                    [Utility showString:error.localizedDescription onView:weakSelf.view];
                    return ;
                }
                NSLog(@"%@", responseObject);
                if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
                    [weakSelf startHeardRefresh];
                } else {
                    [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
                }
            }];
            [Utility showHUDAddedTo:weakSelf.view forTask:_rejectTask];
        }
    }];
}
//立即去代付
- (void)paySection:(NSInteger)section
{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderModel *orderModel = [self.dataArray objectAtIndex:section];
    return orderModel.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = self.dataArray[indexPath.section];
    NSArray *products = orderModel.products;
    OrderProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"OrderProductCell" forIndexPath:indexPath];
    [productCell setContentWithProductModel:products[indexPath.row] andIndexPath:indexPath];
    return productCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;//kScreenWidth/3.5
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderListTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTopCell"];
    [cell setContentWithOrderModel:self.dataArray[section] andSection:section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    PaymentBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentBottomCell"];
    cell.delegate = self;
    [cell setContentWithOrderModel:self.dataArray[section] andSection:section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [tableView fd_heightForCellWithIdentifier:@"PaymentBottomCell" configuration:^(PaymentBottomCell *cell) {
        [cell setContentWithOrderModel:self.dataArray[section] andSection:section];
    }];
    return 49;
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
