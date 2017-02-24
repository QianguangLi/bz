//
//  RepositoryEditViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/15.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryEditViewController.h"
#import "AddressPickerView.h"
#import "NetService.h"
#import "UIView+Addition.h"

@interface RepositoryEditViewController () <UIAlertViewDelegate, AddressPickerViewDelegate>
{
    NSURLSessionTask *_getTask;
    NSURLSessionTask *_task;
    NSString *areaCodeString;
    NSString *areaString;
}
@property (weak, nonatomic) IBOutlet UITextField *repositoryName;
@property (weak, nonatomic) IBOutlet UITextField *repositoryShortName;
@property (weak, nonatomic) IBOutlet AddressPickerView *repositoryAddress;
@property (weak, nonatomic) IBOutlet UITextField *repositoryDetailAddress;
@property (weak, nonatomic) IBOutlet UITextView *repositoryCommnet;

@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *addButton;
@end

@implementation RepositoryEditViewController
- (void)dealloc
{
    [_getTask cancel];
    [_task cancel];
    NSLog(@"RepositoryEditViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    self.title = Localized(@"修改仓库");
    [_repositoryCommnet setBorderCorneRadius:5];
    _repositoryAddress.delegate = self;
    
    [self getRepositoryInfo];
}

- (void)getRepositoryInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _repositoryId, @"whid",
                                 nil];
    WS(weakSelf);
    _getTask = [NetService POST:@"api/Store/WareHoseByidView" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            [weakSelf reloadRepositoryInfo:responseObject[kResponseData]];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_getTask];
}

- (void)reloadRepositoryInfo:(NSDictionary *)dict
{
    _repositoryName.text = dict[@"whname"];
    _repositoryShortName.text = dict[@"whshorename"];
    
    [_repositoryAddress setDefaultAddressWithAreaIDString:dict[@"whaddresscode"]];
    _repositoryDetailAddress.text = dict[@"whaddress"];
    
    areaCodeString = dict[@"whaddresscode"];
    _repositoryCommnet.text = dict[@"remark"];
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
        [_clearButton setTitle:Localized(@"修改") forState:UIControlStateNormal];
        _clearButton.backgroundColor = kPinkColor;
        [_clearButton addTarget:self action:@selector(addRepository:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_clearButton];
    }
}

- (void)addRepository:(UIButton *)btn
{
    if (IS_NULL_STRING(_repositoryName.text)) {
        [Utility showString:Localized(@"请输入仓库名称") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_repositoryShortName.text)) {
        [Utility showString:Localized(@"请输入仓库简码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(areaCodeString)) {
        [Utility showString:Localized(@"请输入地址") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_repositoryDetailAddress.text)) {
        [Utility showString:Localized(@"请输入详细地址") onView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 @"am", @"action",
                                 _repositoryId, @"whid",
                                 _repositoryName.text, @"whname",
                                 _repositoryShortName.text, @"whshortname",
                                 areaCodeString, @"whaddresscode",
                                 _repositoryDetailAddress.text, @"whaddress",
                                 @"", @"dsname",
                                 @"", @"dsshortname",
                                 _repositoryCommnet.text, @"whremark",
                                 @"", @"dsremark",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ManageWareHose" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"修改仓库成功") delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrUpdateRepositorySuccess object:nil];
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
