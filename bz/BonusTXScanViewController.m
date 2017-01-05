//
//  BonusTXScanViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/5.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BonusTXScanViewController.h"
#import "BonusScanCell.h"
#import "NetService.h"
#import "BonusModel.h"

@interface BonusTXScanViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@end

@implementation BonusTXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"奖金提现浏览");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"BonusScanCell" bundle:nil] forCellReuseIdentifier:@"BonusScanCell"];
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
    _task = [NetService POST:kBonusTXScanUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [weakSelf stopRefreshing];
        if (error) {
            NSLog(@"failure:%@", error);
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
            for (NSDictionary *dict in listArray) {
                 BonusModel *model = [[BonusModel alloc] initWithDictionary:dict error:nil];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BonusScanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BonusScanCell" forIndexPath:indexPath];
    [cell setContextWithBonusModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self deleteRowAtIndexPath:indexPath];
    }
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
