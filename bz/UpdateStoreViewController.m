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

@interface UpdateStoreViewController ()
{
    UIButton *_updateButton;
    NSURLSessionTask *_getInfoTask;
    NSURLSessionTask *_task;
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
    
}

- (void)getStoreInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    WS(weakSelf);
    _getInfoTask = [NetService GET:@"api/Store/GetStoreInfo" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
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
- (IBAction)selectStoreLogo:(UIButton *)sender {
}
//TODO:选择店主头像
- (IBAction)selectStoreFace:(UIButton *)sender {
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
