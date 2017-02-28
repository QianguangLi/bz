//
//  CustomerListViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/24.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CustomerListViewController.h"
#import "NetService.h"
#import "CustomerCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>
#import "CustomerModel.h"
#import "AEStoreCustomerViewController.h"
#import "CustomerDetailViewController.h"

const void *alertViewKey1;

@interface CustomerListViewController () <UITableViewDelegate, UITableViewDataSource, CustomerCellDelegate>
{
    NSURLSessionTask *_task;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *cName;
@property (weak, nonatomic) IBOutlet UITextField *sfz;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *qq;
@property (weak, nonatomic) IBOutlet UITextField *wx;

@end

@implementation CustomerListViewController
- (void)dealloc
{
    [_task cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CustomerListViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kAddOrUpdateCustomerSuccess object:nil];
    self.title = Localized(@"客户信息");
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.mTableView registerNib:[UINib nibWithNibName:@"CustomerCell" bundle:nil] forCellReuseIdentifier:@"CustomerCell"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self setupNavigationItem];
    
    [self.view bringSubviewToFront:_searchView];
}

- (void)refresh
{
    //清空数据，刷新
    [self.dataArray removeAllObjects];
    [self.mTableView reloadData];
    [self startRequest];
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

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 _cName.text, @"name",
                                 _sfz.text, @"sfz",
                                 _phone.text, @"mobile",
                                 _qq.text, @"qq",
                                 _wx.text, @"wx",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/QueryClient" parameters:dict complete:^(id responseObject, NSError *error) {
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
            for (NSDictionary *customer in listArray) {
                CustomerModel *model = [[CustomerModel alloc] initWithDictionary:customer error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
    }];
}

#pragma mark - CustomerCellDelegate
- (void)editCustomerAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BZ1Storyboard" bundle:nil];
    AEStoreCustomerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AEStoreCustomerViewController"];
    vc.type = StoreCustomerEdit;
    vc.customerModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteCustomerAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确定要删除库位?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"删除"), nil];
    objc_setAssociatedObject(av, alertViewKey1, indexPath, OBJC_ASSOCIATION_RETAIN);
    [av show];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithCustomerModel:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomerDetailViewController *vc = [[CustomerDetailViewController alloc] init];
    vc.customerModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSIndexPath *indexPath = objc_getAssociatedObject(alertView, alertViewKey1);
        CustomerModel *model = self.dataArray[indexPath.row];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     kLoginToken, @"Token",
                                     @"delete", @"action",
                                     model.id, @"id",
                                     nil];
        WS(weakSelf);
        _task = [NetService POST:@"api/Store/ManageClientInfo" parameters:dict complete:^(id responseObject, NSError *error) {
            [Utility hideHUDForView:weakSelf.view];
            if (error) {
                NSLog(@"failure:%@", error);
                [Utility showString:error.localizedDescription onView:weakSelf.view];
                return ;
            }
            NSLog(@"%@", responseObject);
            if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
            }
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        }];
        [Utility showHUDAddedTo:self.view forTask:_task];
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
