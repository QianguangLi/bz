//
//  BonusTXViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/5.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BonusTXViewController.h"
#import "NetService.h"
#import "UIView+Addition.h"
#import "MMNumberKeyboard.h"

@interface BonusTXViewController () <UIAlertViewDelegate>
{
    NSURLSessionTask *_getBonusTask;//获取奖金任务
    NSURLSessionTask *_task;//提现申请任务
}
@property (weak, nonatomic) IBOutlet UILabel *remind;
@property (weak, nonatomic) IBOutlet UITextField *memberid;
@property (weak, nonatomic) IBOutlet UITextField *payPwd;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *bonusMoney;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *accountName;
@property (weak, nonatomic) IBOutlet UITextField *bankAccount;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation BonusTXViewController
- (void)dealloc
{
    [_getBonusTask cancel];
    [_task cancel];
    NSLog(@"dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"申请奖金提现");
    self.tableView.backgroundColor = QGCOLOR(238, 238, 239, 1);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = view;
    [_submitButton setCorneRadius:5];
    //请求必要数据
    [self requestData];
    //填写默认数据
    _memberid.text = kLoginUserName;
    _accountName.text = kLoginUserName;
    
    MMNumberKeyboard *numberKeyBoard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    numberKeyBoard.allowsDecimalPoint = YES;
    _money.inputView = numberKeyBoard;
}

- (void)requestData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    __weak BonusTXViewController *weakSelf = self;
    _getBonusTask = [NetService GET:@"api/User/GetBonusSet" parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            weakSelf.bonusMoney.text = [NSString stringWithFormat:@"%@", dataDict[@"jjbalance"]];
            weakSelf.remind.text = [NSString stringWithFormat:@"提醒：奖金提现费率为%@,最低提现额为%@", dataDict[@"raise"], dataDict[@"limit"]];
            weakSelf.bankName.text = dataDict[@"bankname"];
            weakSelf.accountName.text = dataDict[@"kaihuname"];
            weakSelf.bankAccount.text = dataDict[@"bankcard"];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}
- (IBAction)submitAction:(UIButton *)sender
{
    if (IS_NULL_STRING(_payPwd.text)) {
        [Utility showString:Localized(@"请输入支付密码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_money.text)) {
        [Utility showString:Localized(@"请输入体现金额") onView:self.view];
        return;
    }
    if (_money.text.doubleValue > _bonusMoney.text.doubleValue) {
        [Utility showString:Localized(@"体现金额不能大于账户余额") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_bankName.text)) {
        [Utility showString:Localized(@"请输入开户银行") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_bankAccount.text)) {
        [Utility showString:Localized(@"请输入银行卡号") onView:self.view];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 [_payPwd.text md5], @"accountpwd",
                                 _money.text, @"withdrawmoney",
                                 _bankAccount.text, @"bankcard",
                                 _bankName.text, @"bankname",
                                 _accountName.text, @"kaihuname",
                                 @"", @"sxf",
                                 _remark.text, @"remark",
                                 nil];
    __weak BonusTXViewController *weakSelf = self;
    _task = [NetService POST:kBonusTXUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            //            NSDictionary *dataDict = responseObject[kResponseData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"申请提现成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
