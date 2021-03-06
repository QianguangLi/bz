//
//  UpdateStoreViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/8.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "UpdateStoreViewController.h"
#import "NetService.h"
#import "UIImageView+AFNetworking.h"
#import <objc/runtime.h>

const void *ImagePickerControllerKey;

@interface UpdateStoreViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *_updateButton;
    NSURLSessionTask *_getInfoTask;
    NSURLSessionTask *_task;
    NSURLSessionTask *_uploadTask;
}

@property (weak, nonatomic) IBOutlet UITextField *storeId;//门店编号
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo;//门店logo
@property (weak, nonatomic) IBOutlet UITextField *memberName;//商户名称
@property (weak, nonatomic) IBOutlet UITextField *storeName;//门店姓名
@property (weak, nonatomic) IBOutlet UIImageView *storeFace;//店主头像
@property (weak, nonatomic) IBOutlet UITextField *email;//电子邮箱
@property (weak, nonatomic) IBOutlet UITextField *mobile;//移动电话
@property (weak, nonatomic) IBOutlet UITextField *storeQQ;//门店QQ
@property (weak, nonatomic) IBOutlet UITextView *comment;//简介
@property (weak, nonatomic) IBOutlet UITextField *registeDate;//注册时间

@end

@implementation UpdateStoreViewController
- (void)dealloc
{
    [_getInfoTask cancel];
    [_task cancel];
    [_uploadTask cancel];
    NSLog(@"UpdateStoreViewController dealloc");
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
        [_updateButton addTarget:self action:@selector(updateStoreInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_updateButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.title = Localized(@"门店信息修改");
    
    [self getStoreInfo];
}

- (void)updateStoreInfo:(UIButton *)btn
{
    if (IS_NULL_STRING(_memberName.text)) {
        [Utility showString:Localized(@"请输入商户名称") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_storeName.text)) {
        [Utility showString:Localized(@"请输入门店名称") onView:self.view];
        return;
    }
    if (![Utility isLegalEmail:_email.text]) {
        [Utility showString:Localized(@"请输入正确电子邮箱") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_mobile.text)) {
        [Utility showString:Localized(@"请输入移动电话") onView:self.view];
        return;
    }
    if (![Utility isLegalMobile:_mobile.text]) {
        [Utility showString:Localized(@"请输入正确手机号") onView:self.view];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _memberName.text, @"memberName",
                                 _storeName.text, @"storename",
                                 _email.text, @"email",
                                 _mobile.text, @"mobile",
                                 _storeQQ.text, @"qq",
                                 _comment.text, @"tips",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ModifyStoreInfo" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"信息修改成功") delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (void)getStoreInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    WS(weakSelf);
    _getInfoTask = [NetService GET:@"api/Store/GetStoreInfo" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            [weakSelf reloadDataWithDict:dataDict];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_getInfoTask];
}

- (void)reloadDataWithDict:(NSDictionary *)dict
{
    _storeId.text = [dict objectForKey:@"storeId"];
    [_storeLogo setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"logoUrl"]] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _memberName.text = [dict objectForKey:@"memberName"];
    _storeName.text = [dict objectForKey:@"storeName"];
    [_storeFace setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"faceUrl"]] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _email.text = [dict objectForKey:@"email"];
    _mobile.text = [dict objectForKey:@"mobile"];
    _storeQQ.text = [dict objectForKey:@"qq"];
    _comment.text = [dict objectForKey:@"tips"];
    _registeDate.text = [dict objectForKey:@"regDate"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TODO:选择门店logo
- (IBAction)selectStoreLogo:(UIButton *)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择") delegate:self cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:Localized(@"相机"), Localized(@"相册"), nil];
    as.tag = 0;
    [as showInView:self.view];
}
//TODO:选择店主头像
- (IBAction)selectStoreFace:(UIButton *)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择") delegate:self cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:Localized(@"相机"), Localized(@"相册"), nil];
    as.tag = 1;
    [as showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            [self invokeImagePiker:UIImagePickerControllerSourceTypeCamera andTag:actionSheet.tag];
        } else {
            [Utility showString:Localized(@"相机不可用") onView:self.view];
        }
    } else if (buttonIndex == 1) {
        //相册
        if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
            [self invokeImagePiker:UIImagePickerControllerSourceTypePhotoLibrary andTag:actionSheet.tag];
        } else {
            [Utility showString:Localized(@"相册不可用") onView:self.view];
        }
    }
}

- (void)invokeImagePiker:(UIImagePickerControllerSourceType)type andTag:(NSInteger)tag
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = type;
    objc_setAssociatedObject(imgPicker, ImagePickerControllerKey, StringFromNumber(tag), OBJC_ASSOCIATION_ASSIGN);
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    NSString *imagePickerControllerKey = objc_getAssociatedObject(picker, ImagePickerControllerKey);
    NSString *action = nil;
    if (imagePickerControllerKey.integerValue == 0) {
        self.storeLogo.image = [UIImage imageWithData:data];
        action = @"storelogo";
    } else {
        self.storeFace.image = [UIImage imageWithData:data];
        action = @"storeface";
    }
    NSString *str = [data base64EncodedStringWithOptions:0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 action, @"action",
                                 str.urlEncode, @"faceBase64",
                                 nil];
    
    WS(weakSelf);
    _uploadTask = [NetService POST:@"api/User/Upload" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"头像上传成功") delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_uploadTask];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
