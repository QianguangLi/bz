//
//  QueryStorageViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/28.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "QueryStorageViewController.h"
#import "NetService.h"
#import "QueryStorageCell.h"

@interface QueryStorageViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *repositoryName;
@property (weak, nonatomic) IBOutlet UITextField *repositoryAddress;
@end

@implementation QueryStorageViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"QueryStorageViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"库存查询");
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.mTableView registerNib:[UINib nibWithNibName:@"QueryStorageCell" bundle:nil] forCellReuseIdentifier:@"QueryStorageCell"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self setupNavigationItem];
    
    [self.view bringSubviewToFront:_searchView];
    
    [self performSelector:@selector(start) withObject:nil afterDelay:2];
}

- (void)start
{
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
//                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 @"2", @"whid",
                                 @"2", @"dsid",
                                 @"", @"commodityname",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/QueryStorage" parameters:dict complete:^(id responseObject, NSError *error) {
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
            for (NSDictionary *orderDict in listArray) {
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryStorageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryStorageCell" forIndexPath:indexPath];
//    cell.delegate = self;
//    [cell setContentWithDict:self.dataArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
