//
//  AEStoreCustomerViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/21.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AEStoreCustomerViewController.h"
#import "NetService.h"
#import "YLButton.h"
#import "UIView+Addition.h"
#import "QGDatePickerView.h"
#import "AddressPickerView.h"
#import "UIImageView+AFNetworking.h"
#import "CustomerModel.h"

@interface AEStoreCustomerViewController () <AddressPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *areaCodeString;
    NSString *areaString;
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet YLButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet AddressPickerView *address;

@property (weak, nonatomic) IBOutlet UIImageView *customerFace;
@property (weak, nonatomic) IBOutlet UITextField *memberId;//商户编号
@property (weak, nonatomic) IBOutlet UITextField *customerName;//客户姓名
@property (weak, nonatomic) IBOutlet UITextField *age;//年龄
@property (weak, nonatomic) IBOutlet UITextField *sex;//性别
@property (weak, nonatomic) IBOutlet UITextField *sfz;//身份证
@property (weak, nonatomic) IBOutlet UITextField *phone;//联系电话
@property (weak, nonatomic) IBOutlet UITextField *mobile;//移动电话
@property (weak, nonatomic) IBOutlet UITextField *qq;//QQ
@property (weak, nonatomic) IBOutlet UITextField *wx;//微信
@property (weak, nonatomic) IBOutlet UITextField *wb;//微博
@property (weak, nonatomic) IBOutlet UITextField *email;//email
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *postolCode;//邮编
@property (weak, nonatomic) IBOutlet UITextView *comment;//其他信息


@property (copy, nonatomic) NSString *birthdayDate;//出生日期
@property (strong, nonatomic) NSString *sexId;//性别 0女 1男

@property (strong, nonatomic) NSArray *sexArray;//性别

@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *currentBtn;

@end

@implementation AEStoreCustomerViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"AEStoreCustomerViewController dealloc");
}

- (void)viewDidLoad {
    
    _birthdayDate = @"";
    areaCodeString = @"";
    
    [super viewDidLoad];
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    self.title = _type == StoreCustomerAdd ? Localized(@"添加客户") : Localized(@"修改客户");
    
    _address.delegate = self;
    
    [_birthdayBtn setBorderCorneRadius:5];
//    _birthdayBtn.bounds = CGRectMake(0, 0, 130, 30);
    [_birthdayBtn setRightImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    
    [self initSexData];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    _sex.inputView = pickerView;
    
    if (_type == StoreCustomerEdit) {
        [self reloadData];
    }
}

- (void)reloadData
{
    [_customerFace setImageWithURL:[NSURL URLWithString:_customerModel.photo] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _memberId.text = _customerModel.memberid;
    _customerName.text = _customerModel.cname;
    _age.text = _customerModel.age;
    
    _sexId = _customerModel.sex;
    _sex.text = _customerModel.sex.integerValue == 0 ? @"女" : @"男";
    
    [_birthdayBtn setTitle:_customerModel.birthday forState:UIControlStateNormal];
    _birthdayDate = _customerModel.birthday;
    
    _sfz.text = _customerModel.sfz;
    _phone.text = _customerModel.phone;
    _mobile.text = _customerModel.mobileTele;
    _qq.text = _customerModel.qq;
    _wx.text = _customerModel.wx;
    _wb.text = _customerModel.wb;
    _email.text = _customerModel.email;
    
    areaCodeString = _customerModel.areacode;
    [_address setDefaultAddressWithAreaIDString:_customerModel.areacode];
    _detailAddress.text = _customerModel.address;
    _postolCode.text = _customerModel.postolCode;
    _comment.text = _customerModel.remark;
}

- (void)initSexData
{
    _sexArray = @[
                   @{@"id":@"1", @"title":@"男"},
                   @{@"id":@"0", @"title":@"女"},
                   ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
    }];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
        [_clearButton setTitle:_type == StoreCustomerAdd ? Localized(@"添加") : Localized(@"修改") forState:UIControlStateNormal];
        _clearButton.backgroundColor = kPinkColor;
        [_clearButton addTarget:self action:@selector(addStoreCustomer:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_clearButton];
    }
}

- (void)addStoreCustomer:(UIButton *)btn
{
    if (IS_NULL_STRING(_memberId.text)) {
        [Utility showString:Localized(@"请输入商户编号") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_customerName.text)) {
        [Utility showString:Localized(@"请输入客户姓名") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_age.text)) {
        [Utility showString:Localized(@"请输入年龄") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_sexId)) {
        [Utility showString:Localized(@"请选择性别") onView:self.view];
        return;
    }
    NSData *data = UIImageJPEGRepresentation(_customerFace.image, 0.7);
    NSString *str = [data base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _type==StoreCustomerAdd?@"0":_customerModel.id, @"id",
                                 str.urlEncode, @"faceBase64",
                                 _memberId.text, @"memberid",
                                 _customerName.text, @"cname",
                                 _age.text, @"age",
                                 _sexId, @"sex",
                                 _birthdayDate, @"birthday",
                                 _sfz.text, @"sfz",
                                 _phone.text, @"phone",
                                 _mobile.text, @"mobileTele",
                                 _qq.text, @"qq",
                                 _wx.text, @"wx",
                                 _wb.text, @"wb",
                                 _email.text, @"email",
                                 areaCodeString, @"areacode",
                                 _detailAddress.text, @"address",
                                 _postolCode.text, @"postolCode",
                                 _comment.text, @"remark",
                                 _type==StoreCustomerAdd?@"add":@"edit", @"action",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ManageClientInfo" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSString *message = weakSelf.type == StoreCustomerAdd ? Localized(@"添加成功") : Localized(@"修改成功");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:message delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

- (IBAction)timeBtnAction:(YLButton *)sender
{
    _currentBtn = sender;
    [self setupCalendar];
}

- (void)setupCalendar {
    
    QGDatePickerView *calendar = [[QGDatePickerView alloc] initWithTrueFrame:CGRectMake(0, kScreenHeight-220, kScreenWidth, 220)];
    
    // 点击某一天的回调
    __weak QGDatePickerView *weakView = calendar;
    calendar.didSelectDayHandler = ^(NSString *dateString) {
        NSLog(@"%@", dateString);
        [_currentBtn setTitle:dateString forState:UIControlStateNormal];
        _birthdayDate = _currentBtn.titleLabel.text;
        [weakView removeFromSuperview];
    };
    calendar.cancleHander = ^(){
        [weakView removeFromSuperview];
    };
    [appDelegate.window addSubview:calendar];
}

- (IBAction)selectedCustomerFace:(UIButton *)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:Localized(@"请选择") delegate:self cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:Localized(@"相机"), Localized(@"相册"), nil];
    [as showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _customerFace.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrUpdateCustomerSuccess object:nil];
}

#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    areaCodeString = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
}

- (void)addressSelectedCountryName:(NSString *)countryName provinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName
{
    NSLog(@"%@,%@,%@,%@", countryName, provinceName, cityName, countyName);
    areaString = [NSString stringWithFormat:@"%@%@%@%@", countryName, provinceName, cityName, countyName];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _sexArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _sexArray[row];
    return dict[@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = _sexArray[row];
    _sexId = dict[@"id"];
    _sex.text = dict[@"title"];
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
