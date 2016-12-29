//
//  LoginViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"
#import "RegistViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginAutoButton;

@property (assign, nonatomic) BOOL isAutoLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"账号登录");
    [self initNavigationItem];
    [_loginButton setImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateNormal];
    [_loginButton setCorneRadius:5];
    
    //TODO:开发模式预设账户密码
    _userNameTF.text = @"lisilisi";
    _passwordTF.text = @"000000";
    
}

- (void)initNavigationItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"取消") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"注册") style:UIBarButtonItemStylePlain target:self action:@selector(registAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)cancelAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:^{
        //code
    }];
}

- (void)registAction:(UIBarButtonItem *)item
{
    //去注册
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)login:(UIButton *)sender
{
    if (IS_NULL_STRING(_userNameTF.text)) {
        [Utility showString:@"账户名不能为空" onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_passwordTF.text)) {
        [Utility showString:@"密码不能为空" onView:self.view];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_userNameTF.text, @"memberid", [_passwordTF.text md5], @"password", nil];
    NSURLSessionTask *task = [NetService POST:kUserLoginUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            return ;
        }
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            //储存登陆数据token
            NSDictionary *dataDict = responseObject[kResponseData];
            kLoginUserName = dataDict[@"username"];
            kLoginToken = dataDict[@"token"];
            kUserLevel = [dataDict[@"access"] integerValue];
            [GlobalData sharedGlobalData].isLogin = YES;
            if (_isAutoLogin) {
                // FIXME:如果是自动登录 执行储存登录信息操作
            }
            //登陆成功后发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:self.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:task];
    
}

- (IBAction)loginAutoAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isAutoLogin = sender.selected;
}

- (IBAction)forgotPassword:(UIButton *)sender
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
