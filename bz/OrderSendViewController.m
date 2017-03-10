//
//  OrderSendViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "OrderSendViewController.h"
#import "OrderSendDetailViewController.h"
#import "MeCell.h"
#import "NetService.h"
#import "YLButton.h"
#import "UIView+Addition.h"
#import "GFCalendar.h"

@interface OrderSendViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}

@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayout;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *orderIdTF;
@property (weak, nonatomic) IBOutlet UITextField *memberIdTF;
@property (weak, nonatomic) IBOutlet UITextField *conNameTF;

@property (weak, nonatomic) IBOutlet YLButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet YLButton *endTimeBtn;

@property (strong, nonatomic) UIButton *currentBtn;

@end

@implementation OrderSendViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"OrderSendViewController dealloc");
}

- (void)viewDidLoad {
    
    _startTime = @"";
    _endTime = @"";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"订单发货");
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.mTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self setupNavigationItem];
    [self setupSearchView];
    
    [self.view bringSubviewToFront:_searchView];
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

- (void)setupSearchView
{
    [_startTimeBtn setBorderCorneRadius:5];
    _startTimeBtn.bounds = CGRectMake(0, 0, (kScreenWidth-62-20-10-10-8)/2, 30);
    [_startTimeBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
    [_endTimeBtn setBorderCorneRadius:5];
    _endTimeBtn.bounds = CGRectMake(0, 0, (kScreenWidth-62-20-10-10-8)/2, 30);
    [_endTimeBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 _orderIdTF.text, @"orderid",
                                 _memberIdTF.text, @"memberid",
                                 _conNameTF.text, @"recename",
                                 _startTime, @"startDate",
                                 _endTime, @"endDate",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/OrderSend" parameters:dict complete:^(id responseObject, NSError *error) {
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

- (IBAction)timeBtnAction:(YLButton *)sender
{
    _currentBtn = sender;
    [self setupCalendar];
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

#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"订单号:%@", self.dataArray[indexPath.row][@"orderId"]];
    cell.subTitleLabel.text = @"查看更多";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderSendDetailViewController *vc = [[OrderSendDetailViewController alloc] init];
    vc.orderId = self.dataArray[indexPath.row][@"orderId"];
    [self.navigationController pushViewController:vc animated:YES];
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
