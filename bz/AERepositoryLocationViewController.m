//
//  AERepositoryLocationViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AERepositoryLocationViewController.h"
#import "UIView+Addition.h"
#import "NetService.h"

@interface AERepositoryLocationViewController () <UIAlertViewDelegate>
{
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UITextField *repositoryName;
@property (weak, nonatomic) IBOutlet UITextField *locationName;
@property (weak, nonatomic) IBOutlet UITextField *locationShortName;
@property (weak, nonatomic) IBOutlet UITextView *locationComment;

@property (strong, nonatomic) UIButton *clearButton;

@end

@implementation AERepositoryLocationViewController
- (void)dealloc
{
    [_task cancel];
    NSLog(@"AERepositoryLocationViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    self.title = _type == RepositoryLocationTypeAdd ? Localized(@"添加库位") : Localized(@"修改库位");
    [_locationComment setBorderCorneRadius:5];
    
    if (_type == RepositoryLocationTypeEdit) {
        [self reloadLocation];
    }
}

- (void)reloadLocation
{
    _repositoryName.text = @"";
    _locationName.text = _locationInfo[@"dsname"];
    _locationShortName.text = _locationInfo[@"dsshorename"];
    _locationComment.text = _locationInfo[@"remark"];
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
        [_clearButton setTitle:_type == RepositoryLocationTypeAdd ? Localized(@"添加") : Localized(@"修改") forState:UIControlStateNormal];
        _clearButton.backgroundColor = kPinkColor;
        [_clearButton addTarget:self action:@selector(addRepositoryLocation:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_clearButton];
    }
}

- (void)addRepositoryLocation:(UIButton *)btn
{
    if (IS_NULL_STRING(_repositoryName.text)) {
        [Utility showString:Localized(@"请输入仓库名称") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_locationName.text)) {
        [Utility showString:Localized(@"请输入库位名称") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_locationShortName.text)) {
        [Utility showString:Localized(@"请输入库位简码") onView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 @"am", @"action",
                                 @"", @"whid",
                                 _type == RepositoryLocationTypeAdd ? @"0" : @"", @"dsid",
                                 _locationName.text, @"dsname",
                                 _locationShortName.text, @"dsshortname",
                                 _locationComment.text, @"dsremark",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ManageDepotSeat" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:_type == RepositoryLocationTypeAdd ? Localized(@"添加库位成功") : Localized(@"修改库位成功") delegate:weakSelf cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrUpdateRepositoryLocationSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
