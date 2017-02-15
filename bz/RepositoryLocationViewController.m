//
//  RepositoryLocationViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/15.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryLocationViewController.h"
#import "RepositoryLocationCell.h"
#import "NetService.h"
#import <objc/runtime.h>

const void *alertViewIndexPathKey;

@interface RepositoryLocationViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, RepositoryLocationCellDelegate>
{
    NSURLSessionTask *_task;
}
@end

@implementation RepositoryLocationViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"RepositoryLocationViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"库位列表");
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.mTableView registerNib:[UINib nibWithNibName:@"RepositoryLocationCell" bundle:nil] forCellReuseIdentifier:@"RepositoryLocationCell"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self setupNavigationItem];
}

- (void)setupNavigationItem
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-add"] style:UIBarButtonItemStylePlain target:self action:@selector(addItemAction:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addItemAction:(UIBarButtonItem *)item
{
    
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _repositoryId, @"whid",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/DepotSeatView" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
//            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:listArray];
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryLocationCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.name.text = self.dataArray[indexPath.row][@"dsname"];
    cell.shortName.text = self.dataArray[indexPath.row][@"dsshorename"];
//    [cell setContentWithDict:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确定要删除库位?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"删除"), nil];
        objc_setAssociatedObject(av, alertViewIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
        [av show];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Localized(@"删除");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSIndexPath *indexPath = objc_getAssociatedObject(alertView, alertViewIndexPathKey);
        
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
