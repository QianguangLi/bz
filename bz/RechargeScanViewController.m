//
//  RechargeScanViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RechargeScanViewController.h"
#import "RechargeScanCell.h"
#import "NetService.h"

@interface RechargeScanViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@end

@implementation RechargeScanViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"充值浏览");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"RechargeScanCell" bundle:nil] forCellReuseIdentifier:@"RechargeScanCell"];
}

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(RefreshViewController *__weak)weakSelf
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 @"", @"startMoney",
                                 @"", @"endMoney",
                                 @"", @"startDate",
                                 @"", @"endDate",
                                 nil];
    _task = [NetService POST:kUserRechargeScanUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [weakSelf stopRefreshing];
        if (error) {
            NSLog(@"failure:%@", error);
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            //            NSString *balance = dataDict[@"balance"];
            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in listArray) {
//                DZMoneyModel *model = [[DZMoneyModel alloc] initWithDictionary:dict error:nil];
//                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeScanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeScanCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
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
