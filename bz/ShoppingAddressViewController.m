//
//  ShoppingAddressViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ShoppingAddressViewController.h"
#import "AddressCell.h"
#import "NetService.h"
#import "ShoppingAddressModel.h"
#import "AddShoppingAddressViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ShoppingAddressViewController () <UITableViewDelegate, UITableViewDataSource, AddressCellDelegate, UIAlertViewDelegate>
{
    NSURLSessionTask *_task;//获取列表任务
    NSURLSessionTask *_delTask;//删除任务
    NSString *_setDefODelId;//要删除的地址id
}
@end

@implementation ShoppingAddressViewController

- (void)dealloc
{
    [_task cancel];
    [_delTask cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kAddOrUpdateShoppingAddressSuccess object:nil];
    self.title = Localized(@"管理收货地址");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
}

- (void)refresh:(NSNotification *)notify
{
    [self startHeardRefresh];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    WS(weakSelf);
    _task = [NetService GET:kGetShoppingAddressUrl parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSArray *dataArray = responseObject[kResponseData];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *addressDict in dataArray) {
                ShoppingAddressModel *model = [[ShoppingAddressModel alloc] initWithDictionary:addressDict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

- (IBAction)addShoppingAddress:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZStoryboard" bundle:nil];
    AddShoppingAddressViewController *vc = (AddShoppingAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddShoppingAddressViewController"];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AddressCellDelegate
- (void)editButtonActionAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingAddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZStoryboard" bundle:nil];
    AddShoppingAddressViewController *vc = (AddShoppingAddressViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddShoppingAddressViewController"];
    vc.isEdit = YES;
    vc.conId = model.conId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteButtonActionAtIndexPath:(NSIndexPath *)indexPath
{
    //获取要删除的地址id
    ShoppingAddressModel *model = self.dataArray[indexPath.row];
    _setDefODelId = model.conId;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确定要删除收货地址?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"确认"), nil];
    //删除提示
    [av show];
}

- (void)setDefaultButtonAtIndexPath:(NSIndexPath *)indexPath
{
    //获取要设置默认地址的地址id
    ShoppingAddressModel *model = self.dataArray[indexPath.row];
    _setDefODelId = model.conId;
    [self updateAddressSetDefOrDel:@"setDefAddr"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self updateAddressSetDefOrDel:@"del"];
    }
}

- (void)updateAddressSetDefOrDel:(NSString *)setDefOrDel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _setDefODelId, @"conaddressid",
                                 setDefOrDel, @"action",
                                 nil];
    WS(weakSelf);
    _delTask = [NetService POST:kSetDefOrDelUrl parameters:dict complete:^(id responseObject, NSError *error) {
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
    [Utility showHUDAddedTo:self.view forTask:_delTask];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithShoppingAddressModel:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 130.0;
    return [tableView fd_heightForCellWithIdentifier:@"AddressCell" cacheByIndexPath:indexPath configuration:^(AddressCell *cell) {
        [cell setContentWithShoppingAddressModel:self.dataArray[indexPath.row] andIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isSelect) {
        ShoppingAddressModel *model = self.dataArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(shoppingAddressViewController:didSelectedShoppingAddressModel:)]) {
            [_delegate shoppingAddressViewController:self didSelectedShoppingAddressModel:model];
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
