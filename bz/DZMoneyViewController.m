//
//  DZMoneyViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "DZMoneyViewController.h"
#import "NetService.h"
#import "GFCalendar.h"
#import "DZMoneyCell.h"
#import "DZMoneyModel.h"
#import "UIView+Addition.h"
#import "DZMoneyDetailsViewController.h"

@interface DZMoneyViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSURLSessionTask *_task;
    UIView *_searchView;
    NSString *_filterString;// -1全部 0转入 1转出
    NSString *_actionString;// 0电子钱包 1积分账户 2奖金账户
    NSString *_startTime;//开始时间
    NSString *_endTime;//结束时间
}

@property (strong, nonatomic) UITextField *currentTextField;
@property (assign, nonatomic) double balance;
@end

@implementation DZMoneyViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"账户明细");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    //默认电子账户 全部 日期为空
    _filterString = @"-1";
    _actionString = @"0";
    _startTime = @"";
    _endTime = @"";
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"DZMoneyCell" bundle:nil] forCellReuseIdentifier:@"DZMoneyCell"];
    
//    [self setupCalendar];
    [self setupNavigationItem];
}

- (void)setupNavigationItem
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemAction:)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)searchItemAction:(UIBarButtonItem *)item
{
    if (!_searchView) {
        float offSet = 0;
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, -offSet, kScreenWidth, offSet)];
        _searchView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_searchView];
        offSet += 20;
        NSArray *arr1 = [NSArray arrayWithObjects:Localized(@"电子钱包"), Localized(@"积分账户"), Localized(@"奖金账户"), nil];
        for (int i = 0; i < arr1.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + ((kScreenWidth-40-arr1.count*80)/(arr1.count-1) + 80)*i, offSet, 80, 30);
            [btn setTitle:arr1[i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.tag = 100 + i;
            if (btn.tag == 100) {
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(kmTypeAction:) forControlEvents:UIControlEventTouchUpInside];
            [_searchView addSubview:btn];
        }
        
        offSet += 50;
        NSArray *arr2 = [NSArray arrayWithObjects:Localized(@"全部"), Localized(@"转入"), Localized(@"转出"), nil];
        for (int i = 0; i < arr2.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20 + ((kScreenWidth-40-arr2.count*80)/(arr2.count-1) + 80)*i, offSet, 80, 30);
            [btn setTitle:arr2[i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.tag = 200 + i - 1;
            if (btn.tag == 199) {
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
            [_searchView addSubview:btn];
        }
        
        offSet += 50;
        NSArray *arr3 = [NSArray arrayWithObjects:Localized(@"起始时间"), Localized(@"结束时间"), nil];
        for (int i = 0; i < arr3.count; i++) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20 + ((kScreenWidth-40-arr3.count*120)/(arr3.count-1) + 100)*i, offSet, 120, 30)];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rili"]];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.tag = 300 + i;
            tf.delegate = self;
            tf.rightView = imageView;
            tf.rightViewMode = UITextFieldViewModeAlways;
            tf.placeholder = arr3[i];
            [_searchView addSubview:tf];
        }
        
        offSet += 50;
        
//        UIButton *startSearch = [UIButton buttonWithType:UIButtonTypeCustom];
//        startSearch.frame = CGRectMake(kScreenWidth/2-120/2, offSet, 120, 30);
//        startSearch.backgroundColor = kPinkColor;
//        [startSearch setTitle:Localized(@"开始查询") forState:UIControlStateNormal];
//        [_searchView addSubview:startSearch];
//        
//        offSet += 50;
        _searchView.frame = CGRectMake(0, -offSet, kScreenWidth, offSet);
    }
    WS(weakSelf);
    if (_searchView.frame.origin.y == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _searchView.frame = CGRectMake(0, -_searchView.frame.size.height, kScreenWidth, _searchView.frame.size.height);
        } completion:^(BOOL finished) {
            [weakSelf startHeardRefresh];
            weakSelf.mTableView.userInteractionEnabled = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _searchView.frame = CGRectMake(0, 0, kScreenWidth, _searchView.frame.size.height);
        } completion:^(BOOL finished) {
            weakSelf.mTableView.userInteractionEnabled = NO;
        }];
    }
}

- (void)kmTypeAction:(UIButton *)btn
{
    NSInteger action = btn.tag - 100;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [_searchView viewWithTag:100+i];
        button.selected = NO;
    }
    btn.selected = YES;
    _actionString = StringFromNumber(action);
}

- (void)directionAction:(UIButton *)btn
{
    NSInteger direction = btn.tag - 200;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [_searchView viewWithTag:200+i-1];
        button.selected = NO;
    }
    btn.selected = YES;
    _filterString = StringFromNumber(direction);
}

- (void)setupCalendar {
    
    CGFloat width = kScreenWidth - 20.0;
    CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    
    // 点击某一天的回调
    __weak GFCalendarView *weakView = calendar;
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%@", [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day]);
        _currentTextField.text = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
        if (_currentTextField.tag == 300) {
            _startTime = _currentTextField.text;
        } else if (_currentTextField.tag == 301) {
            _endTime = _currentTextField.text;
        }
        [weakView removeFromSuperview];
    };
    
    [appDelegate.window addSubview:calendar];
    
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _filterString, @"filter",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 _actionString, @"action",
                                 _startTime, @"startDate",
                                 _endTime, @"endDate",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:kGetUserAccountUrl parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            weakSelf.balance = [dataDict[@"balance"] doubleValue];
            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in listArray) {
                DZMoneyModel *model = [[DZMoneyModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%ld", (long)textField.tag);
    _currentTextField = textField;
    [self setupCalendar];
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DZMoneyCell" forIndexPath:indexPath];
    [cell setContentWithDZMoneyModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DZMoneyDetailsViewController *vc = [[DZMoneyDetailsViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    vc.balanceMoney = self.balance;
    [self.navigationController pushViewController:vc animated:YES];
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
