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

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *previousBtn;

@property (assign, nonatomic) OrderSend type;

@property (strong, nonatomic) UIBarButtonItem *sendItem;//发货

@end

static NSString *OrderInfoDetailCellId = @"OrderInfoDetailCell";
static NSString *OrderInfoSendCellId = @"OrderInfoSendCell";
static NSString *BuyerInfoCellId = @"BuyerInfoCell";
static NSString *ExpressInfoCellId = @"ExpressInfoCell";
static NSString *ReceiptInfoCellId = @"ReceiptInfoCell";
static NSString *ProductInfoCellId = @"ProductInfoCell";
static NSString *OrderProductCellId= @"OrderProductCell";

@implementation OrderSendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (_type == OrderSendDetail) {
                    OrderInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoDetailCellId forIndexPath:indexPath];
                    return cell;
                } else {
                    OrderInfoSendCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoSendCellId forIndexPath:indexPath];
                    return cell;
                }
            }
                break;
            case 1:
            {
                BuyerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:BuyerInfoCellId forIndexPath:indexPath];
                cell.addressLabel.text = @"收货地址:中国 上海市 闵行区 梅龙镇 莘朱路863弄 XXX号 XXX XXX室";
                return cell;
            }
                break;
            case 2:
            {
                ExpressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpressInfoCellId forIndexPath:indexPath];
                cell.addressLabel.text = @"收货地址:中国 上海市 闵行区 梅龙镇 莘朱路863弄 XXX号 XXX XXX室";
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
                cell.addressLabel.text = @"收货地址:中国 上海市 闵行区 梅龙镇 莘朱路863弄 XXX号 XXX XXX室";
            }];
        } else if (indexPath.row == 2) {
            return [tableView fd_heightForCellWithIdentifier:ExpressInfoCellId cacheByIndexPath:indexPath configuration:^(ExpressInfoCell *cell) {
                cell.addressLabel.text = @"收货地址:中国 上海市 闵行区 梅龙镇 莘朱路863弄 XXX号 XXX XXX室";
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
