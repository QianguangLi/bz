//
//  ConfirmOrderViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ConfirmOrderAddressCell.h"
#import "ShoppingCartModel.h"
#import "ConfirmOrderGoodsCell.h"
#import "ConfirmOrderHeader.h"
#import "NetService.h"
#import "ShoppingAddressModel.h"
#import "ShoppingAddressViewController.h"

@interface ConfirmOrderViewController () <UITableViewDelegate, UITableViewDataSource, ShoppingAddressViewControllerDelegate>
{
    NSURLSessionTask *_task;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGoods;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (strong, nonatomic) ShoppingAddressModel *defaultAddressModel;//默认收货地址

@end

@implementation ConfirmOrderViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"确认订单");
    
    self.mTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderAddressCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderAddressCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderGoodsCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderGoodsCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderHeader" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderHeader"];
    
    [self reloadData];
    
    [self getDefaultAddress];
}

- (void)getDefaultAddress
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    [_task cancel];
    WS(weakSelf);
    _task = [NetService GET:@"api/User/GetDefaultConAddress" parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            ShoppingAddressModel *model = [[ShoppingAddressModel alloc] initWithDictionary:dataDict error:nil];
            weakSelf.defaultAddressModel = model;
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

- (void)reloadData
{
    NSInteger numberOfGoods = 0;
    double totalMoney = 0.00;
    for (ShoppingCartModel *shoppingCartModel in _shopppingCartArray) {
        for (ProductModel *model in shoppingCartModel.products) {
            numberOfGoods += model.quantity;
            totalMoney += model.price*model.quantity;
        }
    }
    _numberOfGoods.text = [NSString stringWithFormat:@"共%ld件商品", (long)numberOfGoods];
    _totalMoney.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];
}

#pragma mark - 确认
- (IBAction)confirmAction:(UIButton *)sender {
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        ShoppingCartModel *model = _shopppingCartArray[section-1];
        return model.products.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _shopppingCartArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ConfirmOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderAddressCell" forIndexPath:indexPath];
        [cell setContentWithAddressModel:_defaultAddressModel];
        return cell;
    } else {
        ConfirmOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderGoodsCell" forIndexPath:indexPath];
        ShoppingCartModel *model = _shopppingCartArray[indexPath.section - 1];
        [cell setContentWithProductModel:model.products[indexPath.row]];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //如果是第一行不显示卖家信息
    if (section == 0) {
        return nil;
    } else {
        ConfirmOrderHeader *header = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderHeader"];
        ShoppingCartModel *model = _shopppingCartArray[section - 1];
        [header setContentWithShoppingCartModel:model];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //如果是第一行不显示卖家信息
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"ConfirmOrderAddressCell" cacheByIndexPath:indexPath configuration:^(ConfirmOrderAddressCell *cell) {
            [cell setContentWithAddressModel:_defaultAddressModel];
            }];
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ShoppingAddressViewController *vc = [[ShoppingAddressViewController alloc] init];
        vc.isRequireRefreshHeader = YES;
        vc.isSelect = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ShoppingAddressViewControllerDelegate
- (void)shoppingAddressViewController:(ShoppingAddressViewController *)vc didSelectedShoppingAddressModel:(ShoppingAddressModel *)model
{
    [vc.navigationController popViewControllerAnimated:YES];
    _defaultAddressModel = model;
    [self.mTableView reloadData];
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
