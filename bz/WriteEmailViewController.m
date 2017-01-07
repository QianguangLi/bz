//
//  WriteEmailViewController.m
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "WriteEmailViewController.h"
#import "NetService.h"
#import "UIView+Addition.h"

@interface WriteEmailViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>
{
    NSURLSessionTask *_requestTask;
    NSURLSessionTask *_sendTask;
}
@property (weak, nonatomic) IBOutlet UITextField *reciveName;
@property (weak, nonatomic) IBOutlet UITextField *emailType;
@property (weak, nonatomic) IBOutlet UITextField *emaiTitle;
@property (weak, nonatomic) IBOutlet UITextView *emailContent;

@property (copy, nonatomic) NSString *recivePeople;//接收人
@property (copy, nonatomic) NSString *typeId;//接受类别ID
@property (strong, nonatomic) NSArray *typeArray;//类别数组

@end

@implementation WriteEmailViewController
- (void)dealloc
{
    [_requestTask cancel];
    [_sendTask cancel];
    NSLog(@"dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"写信");
    [_emailContent setBorderCorneRadius:5];
    [self setupNavigation];
    [self requestData];
}

- (void)setupNavigation
{
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"发送") style:UIBarButtonItemStylePlain target:self action:@selector(sendItemAction:)];
    self.navigationItem.rightBarButtonItem = sendItem;
}

- (void)requestData
{
    __weak WriteEmailViewController *weakSelf = self;
    _requestTask = [NetService GET:@"api/User/GetMsgClass" parameters:nil complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            
            NSDictionary *reciveDict = dataDict[@"receive"];
            weakSelf.reciveName.text = reciveDict[@"displayName"];
            weakSelf.recivePeople = reciveDict[@"un"];
            
            weakSelf.typeArray = dataDict[@"classes"];//[NSArray arrayWithArray:dataDict[@"classes"]];
            //设置默认
            weakSelf.emailType.text = [[weakSelf.typeArray firstObject] objectForKey:@"className"];
            weakSelf.typeId = [[weakSelf.typeArray firstObject] objectForKey:@"value"];
            
            UIPickerView *pv = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 229)];
            pv.delegate = weakSelf;
            pv.dataSource = weakSelf;
            weakSelf.emailType.inputView = pv;
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_requestTask];
}

- (void)sendItemAction:(UIBarButtonItem *)item
{
    if (IS_NULL_STRING(_emaiTitle.text)) {
        [Utility showString:Localized(@"请填写信息标题") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_emailContent.text)) {
        [Utility showString:Localized(@"请填写信息内容") onView:self.view];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _emaiTitle.text, @"title",
                                 _emailContent.text, @"content",
                                 _recivePeople, @"recpeople",
                                 _typeId, @"type",
                                 StringFromNumber(_access), @"access",
                                 nil];
    __weak WriteEmailViewController *weakSelf = self;
    _sendTask = [NetService POST:kWriteEmailUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"邮件发送成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_sendTask];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _typeArray[row];
    return dict[@"className"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = _typeArray[row];
    _emailType.text = dict[@"className"];
    _typeId = dict[@"value"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _typeArray.count;
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
