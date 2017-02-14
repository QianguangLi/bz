//
//  RepositoryAddViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RepositoryAddViewController.h"
#import "AddressPickerView.h"
#import "UIView+Addition.h"
#import "NetService.h"

@interface RepositoryAddViewController () <AddressPickerViewDelegate, UIAlertViewDelegate>
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
@property (weak, nonatomic) IBOutlet UITextField *locationName;
@property (weak, nonatomic) IBOutlet UITextField *locationShortName;
@property (weak, nonatomic) IBOutlet UITextView *repositoryCommnet;
@property (weak, nonatomic) IBOutlet UITextView *locationComment;

@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *addButton;

@end

@implementation RepositoryAddViewController
- (void)dealloc
{
    [_getTask cancel];
    [_task cancel];
    NSLog(@"RepositoryAddViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"添加仓库");
    [_repositoryCommnet setBorderCorneRadius:5];
    [_locationComment setBorderCorneRadius:5];
    _repositoryAddress.delegate = self;
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
        [_clearButton setTitle:Localized(@"确定") forState:UIControlStateNormal];
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
    if (IS_NULL_STRING(_locationName.text)) {
        [Utility showString:Localized(@"请输入库位名称") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_locationShortName.text)) {
        [Utility showString:Localized(@"请输入库位简码") onView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 @"am", @"action",
                                 @"0", @"whid",
                                 _repositoryName.text, @"whname",
                                 _repositoryShortName.text, @"whshortname",
                                 areaCodeString, @"whaddresscode",
                                 _repositoryDetailAddress.text, @"whaddress",
                                 _locationName.text, @"dsname",
                                 _locationShortName.text, @"dsshortname",
                                 _repositoryCommnet.text, @"whremark",
                                 _locationComment.text, @"dsremark",
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
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"添加仓库成功") delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
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
