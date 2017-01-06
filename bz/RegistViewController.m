//
//  RegistViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/27.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "RegistViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"

@interface RegistViewController ()
{
    NSURLSessionTask *_task;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneOrEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (assign, nonatomic) BOOL isAgree;//同意注册协议
@property (assign, nonatomic) BOOL isPhoneRegist;//是否是手机注册，否则邮箱注册

@end

@implementation RegistViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"账号注册");
    _isPhoneRegist = YES;//初始化手机注册
    [_loginButton setCorneRadius:5];
}
//登陆
- (IBAction)login:(UIButton *)sender
{
    if (IS_NULL_STRING(_usernameTF.text)) {
        [Utility showString:Localized(@"用户名不能为空") onView:self.view];
        return;
    }
    
    NSString *phoneNumber = nil;
    NSString *email = nil;
    if (_isPhoneRegist) {
        //TODO:验证手机号
        if (IS_NULL_STRING(_phoneTF.text)) {
            [Utility showString:Localized(@"手机号不能为空") onView:self.view];
            return;
        }
        if (![Utility isLegalMobile:_phoneTF.text]) {
            [Utility showString:Localized(@"请正确输入手机号") onView:self.view];
            return;
        }
        phoneNumber = _phoneTF.text;
        email = @"\"\"";
    } else {
        //TODO:验证邮箱
        if (IS_NULL_STRING(_phoneTF.text)) {
            [Utility showString:Localized(@"电子邮箱不能为空") onView:self.view];
            return;
        }
        if (![Utility isLegalEmail:_phoneTF.text]) {
            [Utility showString:Localized(@"请正确输入电子邮箱账号") onView:self.view];
            return;
        }
        phoneNumber = @"\"\"";
        email = _phoneTF.text;
    }
    //TODO:暂时没有验证码
//    if (IS_NULL_STRING(_verifyTF.text)) {
//        [Utility showString:Localized(@"请输入验证码") onView:self.view];
//        return;
//    }
    
    if (IS_NULL_STRING(_passwordTF.text)) {
        [Utility showString:Localized(@"请输入密码") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_confirmPwdTF.text)) {
        [Utility showString:Localized(@"请输入确认密码") onView:self.view];
        return;
    }
    if (![_passwordTF.text isEqualToString:_confirmPwdTF.text]) {
        [Utility showString:Localized(@"两次输入密码不一致") onView:self.view];
        return;
    }
    
    if (!_isAgree) {
        [Utility showString:Localized(@"请先同意用户注册协议") onView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _usernameTF.text, @"memberid",
                                 [_passwordTF.text md5], @"password",
                                 phoneNumber, @"mobile",
                                 email, @"email", nil];
    __weak RegistViewController *weakSelf = self;
    _task = [NetService POST:kUserRegistUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        NSLog(@"%@", responseObject[kErrMsg]);
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}
//是否同意
- (IBAction)agreeAction:(UIButton *)sender
{
    _agreeButton.selected = !sender.selected;
    _isAgree = _agreeButton.selected;
}
//切换注册方式
- (IBAction)switchAction:(UIButton *)sender
{
    _isPhoneRegist = !_isPhoneRegist;
    if (_isPhoneRegist) {
        _phoneOrEmailLabel.text = Localized(@"手机号");
        [_switchButton setTitle:Localized(@"邮箱注册") forState:UIControlStateNormal];
        _phoneTF.placeholder = Localized(@"请输入手机号");
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    } else {
        _phoneOrEmailLabel.text = Localized(@"电子邮箱");
        [_switchButton setTitle:Localized(@"手机注册") forState:UIControlStateNormal];
        _phoneTF.placeholder = Localized(@"请输入电子邮箱账号");
        _phoneTF.keyboardType = UIKeyboardTypeEmailAddress;
    }
    _phoneTF.text = @"";//切换注册方式后置空
}
//注册协议
- (IBAction)registProtocol:(UIButton *)sender
{
    
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
