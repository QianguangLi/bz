//
//  RepositoryListViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryListViewController.h"
#import "RepositoryCell.h"
#import "NetService.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>

@interface RepositoryListViewController () <UITableViewDelegate, UITableViewDataSource, RepositoryCellDelegate, UIAlertViewDelegate>
{
    NSURLSessionTask *_task;
}
@end
const void *alertViewKey;
@implementation RepositoryListViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"RepositoryListViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"仓库管理");
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.mTableView registerNib:[UINib nibWithNibName:@"RepositoryCell" bundle:nil] forCellReuseIdentifier:@"RepositoryCell"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 @"", @"whname",
                                 @"", @"whaddress",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/WareHoseView" parameters:dict complete:^(id responseObject, NSError *error) {
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
    RepositoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithDict:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"RepositoryCell" cacheByIndexPath:indexPath configuration:^(RepositoryCell *cell) {
        [cell setContentWithDict:weakSelf.dataArray[indexPath.row] andIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确定要删除库位?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"删除"), nil];
        objc_setAssociatedObject(av, alertViewKey, indexPath, OBJC_ASSOCIATION_RETAIN);
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
        NSIndexPath *indexPath = objc_getAssociatedObject(alertView, alertViewKey);
        
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
