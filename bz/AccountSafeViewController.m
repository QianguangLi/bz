//
//  AccountSafeViewController.m
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"

@interface AccountSafeViewController () <UIAlertViewDelegate>
{
    NSString *_action; // login 登录密码  pay 支付密码
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UIButton *loginPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *payPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;

@property (strong, nonatomic) UIButton *previousBtn;
@end

@implementation AccountSafeViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = Localized(@"修改密码");
    [_loginPwdBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    [_payPwdBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];

    //默认登录密码
    _loginPwdBtn.selected = YES;
    _previousBtn = _loginPwdBtn;
}

- (IBAction)confirmAction:(UIButton *)sender
{
    if (IS_NULL_STRING(_oldPwd.text)) {
        [Utility showString:Localized(@"请输入原密码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_password.text)) {
        [Utility showString:Localized(@"请输入新密码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_confirmPwd.text)) {
        [Utility showString:Localized(@"请输入确认密码") onView:self.view];
        return;
    }
    if (![_password.text isEqualToString:_confirmPwd.text]) {
        [Utility showString:Localized(@"两次输入密码不一致") onView:self.view];
        return;
    }
    if (_previousBtn == _loginPwdBtn) {
        _action = @"login";
    } else {
        _action = @"pay";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _oldPwd.text, @"oldPwd",
                                 _password.text, @"newPwd",
                                 _action, @"action",
                                 nil];
    __weak AccountSafeViewController *weakSelf = self;
    _task = [NetService POST:kUserLoginUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"密码修改成功") delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:Localized(@"确认"), nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (IBAction)switchAction:(UIButton *)sender
{
    if (_previousBtn == sender) {
        return;
    }
    _previousBtn.selected = NO;
    sender.selected = YES;
    _oldPwd.text = @"";
    _password.text = @"";
    _confirmPwd.text = @"";
    _previousBtn = sender;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
