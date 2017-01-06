//
//  OrderListViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "OrderListViewController.h"
#import "MJRefresh.h"
#import "NetService.h"
#import "OrderModel.h"
#import "OrderListTopCell.h"
#import "OrderProductCell.h"
#import "OrderListBottomCell.h"

@interface OrderListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@end

@implementation OrderListViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OrderListCell"];
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-49);
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderListTopCell" bundle:nil] forCellReuseIdentifier:@"OrderListTopCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderProductCell" bundle:nil] forCellReuseIdentifier:@"OrderProductCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderListBottomCell" bundle:nil] forCellReuseIdentifier:@"OrderListBottomCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(RefreshViewController *__weak)weakSelf
{
//    NSLog(@"%@ %@ %@ %@ ", kLoginToken, StringFromNumber(self.pageIndex), StringFromNumber(self.pageSize))
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                 StringFromNumber(weakSelf.pageSize), kPageSize,
                                 StringFromNumber(_orderType), @"payStatus",
                                 @"", @"orderid", nil];
    _task = [NetService POST:kGetMyOrders parameters:dict complete:^(id responseObject, NSError *error) {
        [weakSelf stopRefreshing];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderModel *orderModel = [self.dataArray objectAtIndex:section];
    return orderModel.products.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = self.dataArray[indexPath.section];
    NSArray *products = orderModel.products;
    if (indexPath.row == 0) {
        OrderListTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTopCell" forIndexPath:indexPath];
        [topCell setContentWithOrderModel:orderModel];
        return topCell;
    } else if (indexPath.row == products.count + 1) {
        OrderListBottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"OrderListBottomCell" forIndexPath:indexPath];
        return bottomCell;
    } else {
        OrderProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"OrderProductCell" forIndexPath:indexPath];
        [productCell setContentWithProductModel:products[indexPath.row - 1]];
        return productCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = self.dataArray[indexPath.section];
    NSArray *products = orderModel.products;
    if (indexPath.row == 0) {
        return 35;
    } else if (indexPath.row == products.count + 1) {
        return 49;
    } else {
        return 91;//kScreenWidth/3.5
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
