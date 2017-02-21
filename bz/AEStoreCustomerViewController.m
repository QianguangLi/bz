//
//  AEStoreCustomerViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/21.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AEStoreCustomerViewController.h"
#import "NetService.h"
#import "YLButton.h"
#import "UIView+Addition.h"
#import "GFCalendar.h"
#import "AddressPickerView.h"

@interface AEStoreCustomerViewController () <AddressPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *areaCodeString;
    NSString *areaString;
}
@property (weak, nonatomic) IBOutlet YLButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet AddressPickerView *address;

@property (weak, nonatomic) IBOutlet UITextField *memberId;//商户编号
@property (weak, nonatomic) IBOutlet UITextField *customerName;//客户姓名
@property (weak, nonatomic) IBOutlet UITextField *age;//年龄
@property (weak, nonatomic) IBOutlet UITextField *sex;//性别
@property (weak, nonatomic) IBOutlet UITextField *sfz;//身份证
@property (weak, nonatomic) IBOutlet UITextField *phone;//联系电话
@property (weak, nonatomic) IBOutlet UITextField *mobile;//移动电话
@property (weak, nonatomic) IBOutlet UITextField *qq;//QQ
@property (weak, nonatomic) IBOutlet UITextField *wx;//微信
@property (weak, nonatomic) IBOutlet UITextField *wb;//微博
@property (weak, nonatomic) IBOutlet UITextField *email;//email
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *postolCode;//邮编
@property (weak, nonatomic) IBOutlet UITextView *comment;//其他信息


@property (copy, nonatomic) NSString *birthdayDate;//出生日期
@property (strong, nonatomic) NSString *sexId;//性别 0女 1男

@property (strong, nonatomic) NSArray *sexArray;//性别

@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *currentBtn;

@end

@implementation AEStoreCustomerViewController

- (void)viewDidLoad {
    
    _birthdayDate = @"";
    
    [super viewDidLoad];
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    self.title = _type == StoreCustomerAdd ? Localized(@"添加客户") : Localized(@"修改客户");
    
    _address.delegate = self;
    
    [_birthdayBtn setBorderCorneRadius:5];
    _birthdayBtn.bounds = CGRectMake(0, 0, (kScreenWidth-62-20-10-10-8)/2, 30);
    [_birthdayBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
    [self initSexData];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    _sex.inputView = pickerView;
}

- (void)initSexData
{
    _sexArray = @[
                   @{@"id":@"1", @"title":@"男"},
                   @{@"id":@"0", @"title":@"女"},
                   ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
    }];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
        [_clearButton setTitle:_type == StoreCustomerAdd ? Localized(@"添加") : Localized(@"修改") forState:UIControlStateNormal];
        _clearButton.backgroundColor = kPinkColor;
        [_clearButton addTarget:self action:@selector(addStoreCustomer:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_clearButton];
    }
}

- (void)addStoreCustomer:(UIButton *)btn
{
    
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
        _birthdayDate = _currentBtn.titleLabel.text;
        [weakView removeFromSuperview];
    };
    
    [appDelegate.window addSubview:calendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    areaCodeString = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
}

- (void)addressSelectedCountryName:(NSString *)countryName provinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName
{
    NSLog(@"%@,%@,%@,%@", countryName, provinceName, cityName, countyName);
    areaString = [NSString stringWithFormat:@"%@%@%@%@", countryName, provinceName, cityName, countyName];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _sexArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _sexArray[row];
    return dict[@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = _sexArray[row];
    _sexId = dict[@"id"];
    _sex.text = dict[@"title"];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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
