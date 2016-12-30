//
//  UpdateMemberInfoTableViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/30.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "UpdateMemberInfoTableViewController.h"
#import "AddressPickerView.h"
#import "NetService.h"
#import "UserModel.h"

@interface UpdateMemberInfoTableViewController () <AddressPickerViewDelegate>
{
    UIButton *_updateButton;
    NSURLSessionTask *_task;
    NSURLSessionTask *_updateTask;
    NSString *_areaid;//国家地区
}

@property (weak, nonatomic) IBOutlet UITextField *memberName;//会员姓名
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;//手机号码
@property (weak, nonatomic) IBOutlet UITextField *email;//邮箱
@property (weak, nonatomic) IBOutlet UITextField *idCard;//身份证
@property (weak, nonatomic) IBOutlet AddressPickerView *areaCode;//国家区域
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *zipCode;//邮编
@property (weak, nonatomic) IBOutlet UITextField *bankName;//开户行名称
@property (weak, nonatomic) IBOutlet UITextField *accountName;//开户名
@property (weak, nonatomic) IBOutlet UITextField *bankAccount;//开户行账号

@end

@implementation UpdateMemberInfoTableViewController

- (void)dealloc
{
    [_task cancel];
    [_updateTask cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"会员信息修改");
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    _areaCode.delegate = self;
    
    [self getMemberInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
    }];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
        [_updateButton setTitle:Localized(@"修改") forState:UIControlStateNormal];
        _updateButton.backgroundColor = kPinkColor;
        [_updateButton addTarget:self action:@selector(updateMemberInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_updateButton];
    }
}

- (void)getMemberInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    __block UpdateMemberInfoTableViewController *weakSelf = self;
    _task = [NetService GET:kGetMemberInfoUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            //            UserModel *userModel = [[UserModel alloc] initWithDict:dataDict];
            UserModel *userModel = [[UserModel alloc] initWithDictionary:dataDict error:nil];
            [weakSelf reloadData:userModel With:weakSelf];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:self.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (void)reloadData:(UserModel *)userModel With:(UpdateMemberInfoTableViewController * __weak)weakSelf
{
    weakSelf.memberName.text = userModel.loginName;
    weakSelf.phoneNumber.text = userModel.mobile;
    weakSelf.email.text = userModel.email;
    weakSelf.idCard.text = userModel.idCard;
    weakSelf.detailAddress.text = userModel.address;
    weakSelf.zipCode.text = userModel.zipCode;
    weakSelf.bankName.text = userModel.bankName;
    weakSelf.accountName.text = userModel.accountName;
    weakSelf.bankAccount.text = userModel.bankAccount;
}

- (void)updateMemberInfo:(UIButton *)btn
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _memberName.text, @"Membername",
                                 _phoneNumber.text, @"Memberphone",
                                 _email.text, @"Memberemail",
                                 _idCard.text, @"Memberidcard",
                                 _detailAddress.text, @"Memberaddress",
                                 _zipCode.text, @"Memberzip",
                                 _bankName.text, @"BankName",
                                 _accountName.text, @"BankAccount",
                                 _bankAccount.text, @"AccountName",
                                 _areaid, @"Areacode",
                                 nil];
    NSLog(@"%@", dict);
    _updateTask = [NetService POST:kUpdateMember parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:self.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_updateTask];
}

#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    _areaid = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
