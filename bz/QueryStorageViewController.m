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

@interface QueryStorageViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_getTask;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *goodsName;//商品名称
@property (weak, nonatomic) IBOutlet UITextField *repositoryName;//仓库
@property (weak, nonatomic) IBOutlet UITextField *loacationAddress;//库位

@property (copy, nonatomic) NSString *repositoryId;//仓库id
@property (copy, nonatomic) NSString *locationId;//库位id

@property (strong, nonatomic) UIPickerView *repositoryPV;
@property (strong, nonatomic) UIPickerView *locationPV;

@property (strong, nonatomic) NSMutableArray *repositoryArray;//仓库数组
@property (strong, nonatomic) NSMutableArray *locationArray;//库位数组

@property (strong, nonatomic) UIBarButtonItem *searchItem;

@end

@implementation QueryStorageViewController
- (void)dealloc
{
    [_task cancel];
    [_getTask cancel];
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
    
    _repositoryPV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    _repositoryPV.delegate = self;
    _repositoryPV.dataSource = self;
    _repositoryName.inputView = _repositoryPV;
    _locationPV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    _locationPV.delegate = self;
    _locationPV.dataSource = self;
    _loacationAddress.inputView = _locationPV;
    
    [self getRepositoryInfo];
}

- (void)getRepositoryInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    _searchItem.enabled = NO;
    WS(weakSelf);
    _getTask = [NetService POST:@"/api/Store/GetAllWareHose" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            weakSelf.searchItem.enabled = YES;
            NSArray *dataArr = responseObject[kResponseData];
            weakSelf.repositoryArray = [NSMutableArray arrayWithArray:dataArr];
            weakSelf.repositoryId = dataArr.firstObject[@"whid"];
            weakSelf.repositoryName.text = dataArr.firstObject[@"whname"];
            NSArray *arr = dataArr.firstObject[@"storeBit"];
            weakSelf.locationArray = [NSMutableArray arrayWithArray:arr];
            weakSelf.locationId = arr.firstObject[@"dsid"];
            weakSelf.loacationAddress.text = arr.firstObject[@"dsname"];
            [weakSelf.repositoryPV reloadAllComponents];
            [weakSelf.locationPV reloadAllComponents];
            [weakSelf start];
            
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_getTask];
}

- (void)start
{
    [self startRequest];
}

- (void)setupNavigationItem
{
    _searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemAction:)];
    
    self.navigationItem.rightBarButtonItem = _searchItem;
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
                                 _repositoryId, @"whid",
                                 _locationId, @"dsid",
                                 _goodsName.text, @"commodityname",
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
            [weakSelf.dataArray addObjectsFromArray:listArray];
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _repositoryPV) {
        return _repositoryArray.count;
    } else {
        return _locationArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _repositoryPV) {
        return _repositoryArray[row][@"whname"];
    } else {
        return _locationArray[row][@"dsname"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _repositoryPV) {
        //给仓库赋值
        NSDictionary *dict = _repositoryArray[row];
        _repositoryName.text = dict[@"whname"];
        _repositoryId = dict[@"whid"];
        //清空并重新组装库位数组 并给使用默认第一个库位信息给库位赋值
        [_locationArray removeAllObjects];
        [_locationArray addObjectsFromArray:dict[@"storeBit"]];
        _loacationAddress.text = _locationArray.firstObject[@"dsname"];
        _locationId = _locationArray.firstObject[@"dsid"];
        [_locationPV reloadAllComponents];
    } else {
        //给库位赋值
        _loacationAddress.text = _locationArray[row][@"dsname"];
        _locationId = _locationArray[row][@"dsid"];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryStorageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryStorageCell" forIndexPath:indexPath];
//    cell.delegate = self;
    [cell setContentWithDict:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
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
