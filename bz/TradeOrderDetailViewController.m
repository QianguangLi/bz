//
//  TradeOrderDetailViewController.m
//  bz
//
//  Created by qianchuang on 2017/3/10.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "TradeOrderDetailViewController.h"
#import "NetService.h"
#import "TradeBuyerInfoCell.h"
#import "OrderProductCell.h"
#import "ProductInfoCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TradeOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}

@property (strong, nonatomic)  NSDictionary *buyerInfo;

@end

@implementation TradeOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"订单详情");
    
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self registerCellForCellReuseIdentifier:@"TradeBuyerInfoCell"];
    [self registerCellForCellReuseIdentifier:@"ProductInfoCell"];
    [self registerCellForCellReuseIdentifier:@"OrderProductCell"];
    [self getOrderInfo];
}

- (void)getOrderInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _orderId, @"orderId",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/StoreOrderDetails" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            weakSelf.buyerInfo = responseObject[kResponseData];
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                TradeBuyerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeBuyerInfoCell" forIndexPath:indexPath];
                cell.memberId.text = _buyerInfo[@"memberId"];
                cell.memberName.text = _buyerInfo[@"memberName"];
                cell.memberNickName.text = _buyerInfo[@"memberPetName"];
                cell.conName.text = _buyerInfo[@"conName"];
                cell.conPhone.text = _buyerInfo[@"conMobilePhone"];
                cell.memberEmail.text = _buyerInfo[@"memberEmail"];
                cell.conAddress.text = _buyerInfo[@"conAddress"];
                return cell;
            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        OrderProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderProductCell" forIndexPath:indexPath];
        [cell setContentWithProductModel:self.goodsArray[indexPath.row] andIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WS(weakSelf);
            return [tableView fd_heightForCellWithIdentifier:@"TradeBuyerInfoCell" cacheByIndexPath:indexPath configuration:^(TradeBuyerInfoCell *cell) {
                cell.conAddress.text = weakSelf.buyerInfo[@"conAddress"];
            }];
        }
    } else if (indexPath.section == 1) {
        return 91;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInfoCell"];
//        cell.orderId.text = _orderInfo[@"orderid"];
        //        [cell.stateBtn setTitle:_orderDetail[0][@"orderstate"] forState:UIControlStateNormal];
        return cell;
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 65;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
