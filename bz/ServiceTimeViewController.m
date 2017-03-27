//
//  ServiceTimeViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ServiceTimeViewController.h"
#import "NetService.h"
#import "ServiceTimeCell.h"
#import "APServiceTimeViewController.h"

@interface ServiceTimeViewController () <UITableViewDelegate, UITableViewDataSource, ServiceTimeCellDelegate>
{
    NSURLSessionTask *_task;
}
@end

@implementation ServiceTimeViewController

- (void)dealloc
{
    [_task cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"ServiceTimeViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kAddOrUpdateServiceTimeSuccess object:nil];
    self.title = Localized(@"门店级别设置");
    
    [self initView];
    [self initNavigation];
}

- (void)refresh
{
    //清空数据，刷新
    [self.dataArray removeAllObjects];
    [self.mTableView reloadData];
    [self startRequest];
}

- (void)initNavigation
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"添加") style:UIBarButtonItemStyleDone target:self action:@selector(addItemAction:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addItemAction:(UIBarButtonItem *)item
{
    //TODO:添加时间折扣
    APServiceTimeViewController *vc = [[APServiceTimeViewController alloc] init];
    vc.type = ServiceTimeTypeAdd;
    vc.title = Localized(@"添加");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initView
{
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.contentInset = UIEdgeInsetsZero;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"ServiceTimeCell" bundle:nil] forCellReuseIdentifier:@"ServiceTimeCell"];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    WS(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                nil];
    _task = [NetService GET:@"api/Store/GetServicetime" parameters:dict complete:^(id responseObject, NSError *error) {
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
            [weakSelf.dataArray addObjectsFromArray:dataArray];
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - ServiceTimeCellDelegate
- (void)editRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:修改送达时间折扣
    APServiceTimeViewController *vc = [[APServiceTimeViewController alloc] init];
    vc.type = ServiceTimeTypeEdit;
    vc.dict = self.dataArray[indexPath.row];
    vc.title = Localized(@"修改");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceTimeCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithDict:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;//kScreenWidth*100.0/320.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
