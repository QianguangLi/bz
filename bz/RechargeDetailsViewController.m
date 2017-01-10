//
//  RechargeDetailsViewController.m
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "RechargeDetailsViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"

@interface RechargeDetailsViewController () <UIAlertViewDelegate>
{
    NSURLSessionTask *_deleteTask;
}
@property (weak, nonatomic) IBOutlet UIButton *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *memberid;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation RechargeDetailsViewController

- (void)dealloc
{
    [_deleteTask cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"充值浏览");
    
    [_payButton setCorneRadius:5];
    
    [self reloadData];
}

- (void)reloadData
{
    _payStatus.selected = _model.isPay;
    _memberid.text = kLoginUserName;
    _money.text = [NSString stringWithFormat:@"%.2f", _model.remitterSum];
    _time.text = _model.remitTime;
    _note.text = _model.note;
    
    _payButton.hidden = _model.isPay;
    _deleteButton.hidden = _model.isPay;
}

- (IBAction)payAction:(UIButton *)sender
{
    //TODO:支付
}

- (IBAction)deleteAction:(UIButton *)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"确定要删除?") delegate:self cancelButtonTitle:Localized(@"取消") otherButtonTitles:Localized(@"确认"), nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteModel];
    }
}

- (void)deleteModel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _model.id, @"rechargeid",
                                 nil];
    WS(weakSelf);
    _deleteTask = [NetService POST:@"api/User/DelRecharge" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteRechargeSuccessNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_deleteTask];
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
