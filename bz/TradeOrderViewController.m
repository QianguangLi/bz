//
//  TradeOrderViewController.m
//  bz
//
//  Created by qianchuang on 2017/3/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "TradeOrderViewController.h"
#import "NetService.h"
#import "NSObject+Addition.h"
#import "OrderModel.h"
#import "TradeOrderTopCell.h"
#import "OrderProductCell.h"
#import "TradeOrderBottomCell.h"

@interface TradeOrderViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSURLSessionTask *_task;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *pName;
@property (weak, nonatomic) IBOutlet UITextField *pCode;
@property (weak, nonatomic) IBOutlet UITextField *orderId;
@property (weak, nonatomic) IBOutlet UITextField *buyerMember;
@property (weak, nonatomic) IBOutlet UITextField *payStatus;

@property (copy, nonatomic) NSString *payStatusCode;
@property (strong, nonatomic) NSArray *payStatusArray;//-1全部 0未支付 1已支付

@end

@implementation TradeOrderViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"TradeOrderViewController dealloc");
}

- (void)viewDidLoad {
    
    _payStatusCode = @"-1";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"交易订单");
    
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"TradeOrderTopCell" bundle:nil] forCellReuseIdentifier:@"TradeOrderTopCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"OrderProductCell" bundle:nil] forCellReuseIdentifier:@"OrderProductCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"TradeOrderBottomCell" bundle:nil] forCellReuseIdentifier:@"TradeOrderBottomCell"];
    
    [self initPayStatusData];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    _payStatus.inputView = pickerView;
    
    [self setupNavigationItem];
    
    [self.view bringSubviewToFront:_searchView];
}

- (void)setupNavigationItem
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemAction:)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)searchItemAction:(UIBarButtonItem *)item
{
    WS(weakSelf);
    if (_searchViewTopLayout.constant == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _searchViewTopLayout.constant = -_searchView.frame.size.height;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _searchView.hidden = YES;
            [weakSelf startHeardRefresh];
            weakSelf.mTableView.userInteractionEnabled = YES;
        }];
    } else {
        _searchView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            _searchViewTopLayout.constant = 0;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.mTableView.userInteractionEnabled = NO;
        }];
    }
}

- (void)initPayStatusData
{
    _payStatusArray = @[
                  @{@"id":@"-1", @"title":@"全部"},
                  @{@"id":@"0", @"title":@"未支付"},
                  @{@"id":@"1", @"title":@"已支付"},
                  ];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              _pName.text, @"pName",
                              _pCode.text, @"pCode",
                              _orderId.text, @"orderId",
                              _buyerMember.text, @"buyMember",
                              _payStatusCode, @"payStatus",
                              nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 jsonDict.toJson, @"queryJson",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/TradingOrders" parameters:dict complete:^(id responseObject, NSError *error) {
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
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *listArray = dataDict[@"list"];
            for (NSDictionary *orderDict in listArray) {
                OrderModel *model = [[OrderModel alloc] initWithDictionary:orderDict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
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
    TradeOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeOrderTopCell"];
    [cell setContentWithOrderModel:self.dataArray[section] andSection:section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TradeOrderBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeOrderBottomCell"];
//    cell.delegate = self;
    [cell setContentWithOrderModel:self.dataArray[section] andSection:section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _payStatusArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _payStatusArray[row];
    return dict[@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = _payStatusArray[row];
    _payStatusCode = dict[@"id"];
    _payStatus.text = dict[@"title"];
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
