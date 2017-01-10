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
#import "UIImageView+AFNetworking.h"
#import "GTMBase64.h"
#import "AFNetworking.h"

@interface UpdateMemberInfoTableViewController () <AddressPickerViewDelegate, UIAlertViewDelegate, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *_updateButton;
    NSURLSessionTask *_task;
    NSURLSessionTask *_updateTask;//更新任务
    NSURLSessionTask *_uploadTask;//上传头像
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
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (copy, nonatomic) NSString *areaid;//国家地区

@end

@implementation UpdateMemberInfoTableViewController

- (void)dealloc
{
    [_task cancel];
    [_updateTask cancel];
    [_uploadTask cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"会员信息修改");
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
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

- (IBAction)selectHeadAction:(UIButton *)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择") delegate:self cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:Localized(@"相机"), Localized(@"相册"), nil];
    [as showInView:self.view];
}

- (void)getMemberInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:kLoginToken, @"Token", nil];
    WS(weakSelf);
    _task = [NetService GET:kGetMemberInfoUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            //            UserModel *userModel = [[UserModel alloc] initWithDict:dataDict];
            UserModel *userModel = [[UserModel alloc] initWithDictionary:dataDict error:nil];
            [weakSelf reloadData:userModel With:weakSelf];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (void)reloadData:(UserModel *)userModel With:(UpdateMemberInfoTableViewController * __weak)weakSelf
{
    [weakSelf.headImageView setImageWithURL:[NSURL URLWithString:userModel.faceUrl] placeholderImage:[UIImage imageNamed:@"member-head"]];
    
    weakSelf.memberName.text = userModel.loginName;
    weakSelf.phoneNumber.text = userModel.mobile;
    weakSelf.email.text = userModel.email;
    weakSelf.idCard.text = userModel.idCard;
    weakSelf.detailAddress.text = userModel.address;
    weakSelf.zipCode.text = userModel.zipCode;
    weakSelf.bankName.text = userModel.bankName;
    weakSelf.accountName.text = userModel.accountName;
    weakSelf.bankAccount.text = userModel.bankAccount;
    
    weakSelf.areaid = userModel.addrcode;
    
    [weakSelf.areaCode setDefaultAddressWithAreaIDString:userModel.addrcode];
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
                                 _accountName.text, @"AccountName",
                                 _bankAccount.text, @"BankAccount",
                                 _areaid, @"Areacode",
                                 nil];
    NSLog(@"%@", dict);
    WS(weakSelf);
    _updateTask = [NetService POST:kUpdateMember parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
//            NSDictionary *dataDict = responseObject[kResponseData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"信息修改成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:weakSelf.view forTask:_updateTask];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            [self invokeImagePiker:UIImagePickerControllerSourceTypeCamera];
        } else {
            [Utility showString:Localized(@"相机不可用") onView:self.view];
        }
    } else if (buttonIndex == 1) {
        //相册
        if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
            [self invokeImagePiker:UIImagePickerControllerSourceTypePhotoLibrary];
        } else {
            [Utility showString:Localized(@"相册不可用") onView:self.view];
        }
    }
}

- (void)invokeImagePiker:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = type;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
}
//data:image/jpeg;base64,
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    self.headImageView.image = [UIImage imageWithData:data];
    NSString *str = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [data base64EncodedStringWithOptions:0]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 @"memberface", @"action",
                                 str, @"faceBase64",
                                 nil];
//    [self uploadImageWithImage:image];
//    NSLog(@"%@", str);
    WS(weakSelf);
    _uploadTask = [NetService POST:@"api/User/Upload" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"头像上传成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_uploadTask];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadImageWithImage:(UIImage *)image {
    //截取图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    // 参数
    NSString *sign = [[NSString stringWithFormat:@"%@%@",kLoginToken, kSignKey] md5];
    NSDictionary *parameter       = @{@"Token":kLoginToken,@"Sign":sign};
//    };
// 访问路径
NSString *stringURL = @"http://103.48.169.52/bzapi/api/User/Upload";

[manager POST:stringURL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:imageData name:@"faceBase64" fileName:@"head.jpg" mimeType:@"image/jpg"];
    
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"%@", responseObject);
    NSLog(@"上传陈宫");
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"上传失败:%@", error);
}];
}

#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    _areaid = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

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
