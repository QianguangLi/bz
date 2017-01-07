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
#import "RechargeModel.h"
#import "UIView+Addition.h"
#import "GFCalendar.h"
#import "IQKeyboardManager.h"
#import "YLButton.h"
#import "MMNumberKeyboard.h"
#import "RechargeDetailsViewController.h"

@interface RechargeScanViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_deleteTask;//删除任务
    NSString *_payStatus;//订单状态 -1全部 0未支付 1已支付
    NSString *_startMoney;
    NSString *_endMoney;
    NSString *_startTime;
    NSString *_endTime;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *startMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *endMoneyTF;

//@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
//@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet YLButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet YLButton *endTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *notPayButton;
@property (weak, nonatomic) IBOutlet UIButton *payedButton;

@property (strong ,nonatomic) YLButton *currentBtn;

@end

@implementation RechargeScanViewController

- (void)dealloc
{
    [_task cancel];
    [_deleteTask cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kDeleteRechargeSuccessNotification object:nil];
    self.title = Localized(@"充值浏览");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"RechargeScanCell" bundle:nil] forCellReuseIdentifier:@"RechargeScanCell"];
    
    [self setupSearchView];
    //默认全部订单
    _payStatus = @"-1";
    _allButton.selected = YES;
    _notPayButton.selected = NO;
    _payedButton.selected = NO;
    _startTime = @"";
    _endTime = @"";
    
    MMNumberKeyboard *numberKeyboard1 = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    numberKeyboard1.allowsDecimalPoint = YES;
    _startMoneyTF.inputView = numberKeyboard1;
    MMNumberKeyboard *numberKeyboard2 = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    numberKeyboard2.allowsDecimalPoint = YES;
    _endMoneyTF.inputView = numberKeyboard2;
    
    [self.view bringSubviewToFront:_searchView];
    [self setupNavigationItem];
}

- (void)refreshData:(NSNotification *)notify
{
    [self startHeardRefresh];
}

- (void)setupSearchView
{
    [_allButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [_allButton setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    [_notPayButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [_notPayButton setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    [_payedButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [_payedButton setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
//    UIImageView *rightView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rili"]];
//    _startTimeTF.rightView = rightView1;
//    _startTimeTF.rightViewMode = UITextFieldViewModeAlways;
//    UIImageView *rightView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rili"]];
//    _endTimeTF.rightView = rightView2;
//    _endTimeTF.rightViewMode = UITextFieldViewModeAlways;
    
    [_startTimeBtn setBorderCorneRadius:5];
    _startTimeBtn.bounds = CGRectMake(0, 0, (kScreenWidth-62-20-10-10-8)/2, 30);
    [_startTimeBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
    [_endTimeBtn setBorderCorneRadius:5];
    _endTimeBtn.bounds = CGRectMake(0, 0, (kScreenWidth-62-20-10-10-8)/2, 30);
    [_endTimeBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
}

- (void)setupNavigationItem
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemAction:)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (IBAction)timeBtnAction:(YLButton *)sender
{
    _currentBtn = sender;
    [self setupCalendar];
}

- (IBAction)payStatusAction:(UIButton *)sender
{
    NSInteger payStatus = sender.tag - 300;
    _allButton.selected = NO;
    _notPayButton.selected = NO;
    _payedButton.selected = NO;
    sender.selected = YES;
    _payStatus = StringFromNumber(payStatus);
}


- (void)searchItemAction:(UIBarButtonItem *)item
{
    __weak RechargeScanViewController *weakSelf = self;
    if (_searchViewTopLayout.constant == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _searchViewTopLayout.constant = -_searchView.frame.size.height;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf startHeardRefresh];
            weakSelf.mTableView.userInteractionEnabled = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _searchViewTopLayout.constant = 0;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.mTableView.userInteractionEnabled = NO;
        }];
    }
}

- (void)requestDataListPullDown:(BOOL)pullDown withWeakSelf:(RefreshViewController *__weak)weakSelf
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 _payStatus, @"payState",
                                 _startMoneyTF.text, @"startMoney",
                                 _endMoneyTF.text, @"endMoney",
                                 _startTime, @"startDate",
                                 _endTime, @"endDate",
                                 nil];
    _task = [NetService POST:kUserRechargeScanUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [weakSelf stopRefreshing];
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
            for (NSDictionary *dict in listArray) {
                RechargeModel *model = [[RechargeModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
    }];
}

- (void)setupCalendar {
    
    CGFloat width = kScreenWidth - 20.0;
    CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    
    // 点击某一天的回调
    __weak GFCalendarView *weakView = calendar;
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%@", [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day]);
        [_currentBtn setTitle:[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day] forState:UIControlStateNormal];
        if (_currentBtn.tag == 200) {
            _startTime = _currentBtn.titleLabel.text;
        } else if (_currentBtn.tag == 201) {
            _endTime = _currentBtn.titleLabel.text;
        }
        [weakView removeFromSuperview];
    };
    
    [appDelegate.window addSubview:calendar];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeModel *model = self.dataArray[indexPath.row];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 model.id, @"rechargeid",
                                 nil];
    __weak RechargeScanViewController *weakSelf = self;
    _deleteTask = [NetService POST:@"api/User/DelRecharge" parameters:dict complete:^(id responseObject, NSError *error) {
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
//            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
    }];
    [Utility showHUDAddedTo:self.view forTask:_deleteTask];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeScanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeScanCell" forIndexPath:indexPath];
    [cell setContentWithRechargeModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RechargeDetailsViewController *vc = [[RechargeDetailsViewController alloc] init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRowAtIndexPath:indexPath];
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
