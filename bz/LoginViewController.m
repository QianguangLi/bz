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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
    _userNameTF.text = @"liqianguang";
    _passwordTF.text = @"8888888888";
}

- (void)initNavigationItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"取消") style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:^{
        //code
    }];
}

- (IBAction)login:(UIButton *)sender
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_userNameTF.text, @"memberid", [_passwordTF.text md5], @"password", nil];
    NSLog(@"%@", dict);
    [NetService POST:kUserLoginUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            return ;
        }
        NSLog(@"%@", responseObject);
    }];
    [Utility showHUDAddedTo:self.view];
    
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
