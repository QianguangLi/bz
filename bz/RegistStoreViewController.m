//
//  RegistStoreViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RegistStoreViewController.h"
#import "NetService.h"
#import "AddressPickerView.h"
#import "UserModel.h"

@interface RegistStoreViewController () <AddressPickerViewDelegate, UIAlertViewDelegate>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_registTask;
}
@property (weak, nonatomic) IBOutlet UITextField *memberid;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet AddressPickerView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *detailAddr;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankAccount;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) UIButton *registButton;

@property (assign, nonatomic) BOOL isAgree;//是否同意
@property (copy, nonatomic) NSString *areaCode;//地址编码

@end

@implementation RegistStoreViewController

- (void)dealloc
{
    [_task cancel];
    [_registTask cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"门店申请");
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //设置初始状态
    _isAgree = NO;
    _areaCode = @"";
    _addressView.delegate = self;
    
    [self getMemberInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:CGFLOAT_MIN animations:^{
        
    } completion:^(BOOL finished) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
        if (!_registButton) {
            _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _registButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
            [_registButton setTitle:Localized(@"申请") forState:UIControlStateNormal];
            _registButton.backgroundColor = kPinkColor;
            [_registButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableView.superview addSubview:_registButton];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)getMemberInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    __block RegistStoreViewController *weakSelf = self;
    _task = [NetService GET:kGetMemberInfoUrl parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            UserModel *userModel = [[UserModel alloc] initWithDictionary:dataDict error:nil];
            [weakSelf reloadData:userModel With:weakSelf];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

- (void)reloadData:(UserModel *)userModel With:(RegistStoreViewController * __weak)weakSelf
{
    weakSelf.memberid.text = userModel.loginName;
    weakSelf.mobile.text = userModel.mobile;
//    weakSelf.email.text = userModel.email;
    weakSelf.detailAddr.text = userModel.address;
//    weakSelf.bankName.text = userModel.bankName;
//    weakSelf.bankAccount.text = userModel.bankAccount;
    
    weakSelf.areaCode = userModel.addrcode;
    
    [weakSelf.addressView setDefaultAddressWithAreaIDString:userModel.addrcode];
}

- (void)registAction:(UIButton *)btn
{
    if (IS_NULL_STRING(_memberid.text)) {
        [Utility showString:Localized(@"请填写门店编号") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_mobile.text)) {
        [Utility showString:Localized(@"请填写手机号码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_email.text)) {
        [Utility showString:Localized(@"请填写电子邮箱") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_areaCode)) {
        [Utility showString:Localized(@"请选择会员地址") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_detailAddr.text)) {
        [Utility showString:Localized(@"请填写详细地址") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_bankName.text)) {
        [Utility showString:Localized(@"请填写开会银行") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_bankAccount.text)) {
        [Utility showString:Localized(@"请填写银行卡号") onView:self.view];
        return;
    }
    if (!_isAgree) {
        [Utility showString:Localized(@"请同意经营协议") onView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _mobile.text, @"mobile",
                                 _email.text, @"email",
                                 _areaCode, @"areacode",
                                 _detailAddr.text, @"addr",
                                 _bankName.text, @"bankName",
                                 _bankAccount.text, @"bankAccount",
                                 nil];
    __weak RegistStoreViewController *weakSelf = self;
    _registTask = [NetService POST:@"/api/User/ApplyStore" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            //            NSDictionary *dataDict = responseObject[kResponseData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:weakSelf.view forTask:_registTask];
}

- (IBAction)agreeAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isAgree = sender.selected;
}
//门店入住协议
- (IBAction)scanProtocal:(UIButton *)sender
{
    //TODO:门店注入协议
    
}

#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    _areaCode = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        }
        return;
    }
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
