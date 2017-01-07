//
//  DZMoneyRechargeViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "DZMoneyRechargeViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"
#import "MMNumberKeyboard.h"

@interface DZMoneyRechargeViewController () <UIAlertViewDelegate>
{
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UITextField *usename;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *rechargeAccount;
@property (weak, nonatomic) IBOutlet UITextView *rechageNote;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation DZMoneyRechargeViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"电子钱包充值");
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = view;
    
    [_submitButton setCorneRadius:5];
    [_rechageNote setBorderCorneRadius:5];
    
    _usename.text = kLoginUserName;
    
    MMNumberKeyboard *numberKeyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    numberKeyboard.allowsDecimalPoint = YES;
    _money.inputView = numberKeyboard;
}
- (IBAction)submitAction:(UIButton *)sender
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _money.text, @"rechargemoney",
                                 _rechageNote.text, @"note",
                                 nil];
    __weak DZMoneyRechargeViewController *weakSelf = self;
    _task = [NetService POST:kUserRechargeUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            //            NSDictionary *dataDict = responseObject[kResponseData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"提交成功成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //TODO:充值后期操作
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
