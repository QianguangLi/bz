//
//  APServiceTimeViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "APServiceTimeViewController.h"
#import "MMNumberKeyboard.h"
#import "NetService.h"

@interface APServiceTimeViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UITextField *jbTF;
@property (weak, nonatomic) IBOutlet UITextField *zkTF;

@property (strong, nonatomic) NSArray *dataArray;

@property (copy, nonatomic) NSString *stid;//送达时间折扣id

@end

@implementation APServiceTimeViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"APServiceTimeViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_type == ServiceTimeTypeEdit) {
        _jbTF.enabled = NO;
        _jbTF.text = [_dict objectForKey:@"jb"];
        _zkTF.text = [_dict objectForKey:@"zk"];
        _stid = [_dict objectForKey:@"stid"];
    } else {
        _stid = @"-1";//默认请选择
    }
    
    [self initData];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    _jbTF.inputView = pickerView;
    
    MMNumberKeyboard *numberKeyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    numberKeyboard.allowsDecimalPoint = YES;
    _zkTF.inputView = numberKeyboard;
}

- (void)initData
{
    _dataArray = @[
                   @{@"id":@"-1", @"title":@"请选择"},
                   @{@"id":@"1", @"title":@"级别1"},
                   @{@"id":@"2", @"title":@"级别2"},
                   @{@"id":@"3", @"title":@"级别3"},
                   @{@"id":@"4", @"title":@"级别4"},
                   @{@"id":@"5", @"title":@"级别5"},
                   @{@"id":@"6", @"title":@"级别6"}
                   ];
}

- (IBAction)submit:(UIButton *)sender
{
    if (_stid.integerValue == -1) {
        [Utility showString:Localized(@"请选择级别") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_zkTF.text)) {
        [Utility showString:Localized(@"请输入折扣") onView:self.view];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _stid, @"stid",
                                 _zkTF.text, @"zk",
                                 _jbTF.text, @"jb",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ManageServicetime" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSString *message = weakSelf.type == ServiceTimeTypeAdd ? Localized(@"添加成功") : Localized(@"修改成功");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:message delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
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
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrUpdateServiceTimeSuccess object:nil];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _dataArray[row];
    return dict[@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = _dataArray[row];
    _stid = dict[@"stid"];
    _jbTF.text = dict[@"title"];
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
