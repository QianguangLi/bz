//
//  OrderSendViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "OrderSendDetailViewController.h"
#import "UIView+Addition.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetService.h"

#import "OrderInfoSendCell.h"
#import "OrderInfoDetailCell.h"
#import "BuyerInfoCell.h"
#import "ExpressInfoCell.h"
#import "ReceiptInfoCell.h"
#import "ProductInfoCell.h"
#import "OrderProductCell.h"

typedef enum : NSInteger {
    OrderSendDetail,
    OrderSendSend,
} OrderSend;

@interface OrderSendDetailViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *previousBtn;

@property (assign, nonatomic) OrderSend type;

@property (strong, nonatomic) UIBarButtonItem *sendItem;//发货

@property (strong, nonatomic) NSMutableArray *orderDetail;
@property (strong, nonatomic) NSDictionary *orderInfo;

@end

static NSString *OrderInfoDetailCellId = @"OrderInfoDetailCell";
static NSString *OrderInfoSendCellId = @"OrderInfoSendCell";
static NSString *BuyerInfoCellId = @"BuyerInfoCell";
static NSString *ExpressInfoCellId = @"ExpressInfoCell";
static NSString *ReceiptInfoCellId = @"ReceiptInfoCell";
static NSString *ProductInfoCellId = @"ProductInfoCell";
static NSString *OrderProductCellId= @"OrderProductCell";

@implementation OrderSendDetailViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"OrderSendDetailViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _orderDetail = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = Localized(@"订单信息");
    [_detailBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    //初始化发货按钮
    _sendItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"发货") style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)];
    
    //默认明细
    _detailBtn.selected = YES;
    _type = OrderSendDetail;
    _previousBtn = _detailBtn;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44-64) style:UITableViewStyleGrouped];
    _tableView.sectionFooterHeight = 0;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    _tableView.sectionHeaderHeight = 0;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = QGCOLOR(238, 238, 239, 1);
//    _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self registCell];
    
    [self getOrderInfo];
}

- (void)getOrderInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _orderId, @"orderid",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/OrderSendDetails" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            weakSelf.orderInfo = responseObject[kResponseData];
            NSArray *arr = weakSelf.orderInfo[@"orderdetail"];
            for (NSDictionary *orderDetail in arr) {
                ProductModel *model = [[ProductModel alloc] initWithDictionary:orderDetail error:nil];
                [weakSelf.orderDetail addObject:model];
            }
            [weakSelf.tableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (void)sendAction:(UIBarButtonItem *)item
{
    //TODO:发货
}

- (void)registCell
{
    [_tableView registerNib:[UINib nibWithNibName:OrderInfoDetailCellId bundle:nil] forCellReuseIdentifier:OrderInfoDetailCellId];
    [_tableView registerNib:[UINib nibWithNibName:OrderInfoSendCellId bundle:nil] forCellReuseIdentifier:OrderInfoSendCellId];
    [_tableView registerNib:[UINib nibWithNibName:BuyerInfoCellId bundle:nil] forCellReuseIdentifier:BuyerInfoCellId];
    [_tableView registerNib:[UINib nibWithNibName:ExpressInfoCellId bundle:nil] forCellReuseIdentifier:ExpressInfoCellId];
    [_tableView registerNib:[UINib nibWithNibName:ReceiptInfoCellId bundle:nil] forCellReuseIdentifier:ReceiptInfoCellId];
    [_tableView registerNib:[UINib nibWithNibName:ProductInfoCellId bundle:nil] forCellReuseIdentifier:ProductInfoCellId];
    [_tableView registerNib:[UINib nibWithNibName:OrderProductCellId bundle:nil] forCellReuseIdentifier:OrderProductCellId];
}

- (IBAction)switchAction:(UIButton *)sender
{
    if (_previousBtn == sender) {
        return;
    }
    _previousBtn.selected = NO;
    sender.selected = YES;
    _type = sender.tag;
    if (_type == OrderSendDetail) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = _sendItem;
    }
    _previousBtn = sender;
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return self.orderDetail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (_type == OrderSendDetail) {
                    OrderInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoDetailCellId forIndexPath:indexPath];
                    cell.orderId.text = _orderInfo[@"orderid"];
                    cell.orderTime.text = _orderInfo[@"ordertime"];
                    cell.orderTime.text = _orderInfo[@"ordertime"];
                    cell.totalMoney.text = _orderInfo[@"totalmoney"];
                    cell.orderState.text = _orderInfo[@"orderstate"];
                    cell.payTime.text = _orderInfo[@"paytime"];
                    cell.orderType.text = _orderInfo[@"ordertype"];
                    cell.jfPay.text = _orderInfo[@"jfpay"];
                    cell.sendType.text = _orderInfo[@"sendtype"];
                    cell.note.text = _orderInfo[@"remark"];
                    return cell;
                } else {
                    OrderInfoSendCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoSendCellId forIndexPath:indexPath];
                    cell.orderId.text = _orderInfo[@"orderid"];
                    cell.orderTime.text = _orderInfo[@"ordertime"];
                    cell.orderTime.text = _orderInfo[@"ordertime"];
                    cell.totalMoney.text = _orderInfo[@"totalmoney"];
                    cell.orderState.text = _orderInfo[@"orderstate"];
                    cell.note.text = _orderInfo[@"remark"];
                    return cell;
                }
            }
                break;
            case 1:
            {
                BuyerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:BuyerInfoCellId forIndexPath:indexPath];
                cell.buyerName.text = _orderInfo[@"name"];
                cell.conName.text = _orderInfo[@"recename"];
                cell.conMobile.text = _orderInfo[@"recemobile"];
                cell.addressLabel.text = _orderInfo[@"receaddress"];
                return cell;
            }
                break;
            case 2:
            {
                ExpressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpressInfoCellId forIndexPath:indexPath];
                cell.addressLabel.text = _orderInfo[@"receaddress"];
                return cell;
            }
                break;
            case 3:
            {
                ReceiptInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ReceiptInfoCellId forIndexPath:indexPath];
                return cell;
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        OrderProductCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderProductCellId forIndexPath:indexPath];
        [cell setContentWithProductModel:self.orderDetail[indexPath.row] andIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (_type == OrderSendDetail) {
                return 200;
            } else {
                return 155;
            }
        } else if (indexPath.row == 1) {
            return [tableView fd_heightForCellWithIdentifier:BuyerInfoCellId cacheByIndexPath:indexPath configuration:^(BuyerInfoCell *cell) {
                cell.addressLabel.text = _orderInfo[@"receaddress"];
            }];
        } else if (indexPath.row == 2) {
            return [tableView fd_heightForCellWithIdentifier:ExpressInfoCellId cacheByIndexPath:indexPath configuration:^(ExpressInfoCell *cell) {
                cell.addressLabel.text = _orderInfo[@"receaddress"];
            }];
        } else if (indexPath.row == 3) {
            return 40;
        }
        
    } else if (indexPath.section == 1) {
        return 91;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductInfoCellId];
        cell.orderId.text = _orderInfo[@"orderid"];
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
