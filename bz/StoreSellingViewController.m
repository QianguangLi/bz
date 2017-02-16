//
//  StoreSellingViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/16.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "StoreSellingViewController.h"
#import "UIView+Addition.h"
#import "StoreSellingCell.h"
#import "SellingProductModel.h"
#import "NetService.h"

@interface StoreSellingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_submitTask;
}
@property (weak, nonatomic) IBOutlet UIButton *isSellingBtn;
@property (weak, nonatomic) IBOutlet UIButton *notSellingBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) UIButton *previousBtn;

@property (copy, nonatomic) NSString *sellingType;
@end

@implementation StoreSellingViewController
- (void)dealloc
{
    [_task cancel];
    [_submitTask cancel];
    NSLog(@"StoreSellingViewController dealloc");
}
- (void)viewDidLoad {
    //默认已上架
    _isSellingBtn.selected = YES;
    _previousBtn = _isSellingBtn;
    _sellingType = @"yes";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"商品上下架");
    [_isSellingBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    [_notSellingBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    self.mTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44 - 49);
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.allowsMultipleSelection = YES;
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"StoreSellingCell" bundle:nil] forCellReuseIdentifier:@"StoreSellingCell"];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _sellingType, @"action",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 @"", @"pname",
                                 @"", @"pcustom",
                                 nil];
    _submitBtn.userInteractionEnabled = NO;
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/ProShelves" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *orderDict in listArray) {
                SellingProductModel *model = [[SellingProductModel alloc] initWithDictionary:orderDict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
        weakSelf.submitBtn.userInteractionEnabled = YES;
    }];
}

- (IBAction)switchAction:(UIButton *)sender
{
    if (_previousBtn == sender) {
        return;
    }
    _previousBtn.selected = NO;
    sender.selected = YES;
    _sellingType = sender == _isSellingBtn ? @"yes" : @"no";
    [_submitBtn setTitle:sender == _isSellingBtn ? @"撤销上架" : @"添加商品销售" forState:UIControlStateNormal];
    _previousBtn = sender;
    //切换时取消正在执行的任务
    [_task cancel];
    [self startHeardRefresh];
}

- (IBAction)submit:(UIButton *)sender
{
    NSArray *indexPathArr = self.mTableView.indexPathsForSelectedRows;
    if (IS_NULL_ARRAY(indexPathArr)) {
        [Utility showString:Localized(@"请选择要操作的商品") onView:self.view];
        return;
    }
    NSMutableArray *productIdArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPathArr) {
        SellingProductModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [productIdArr addObject:model.productId];
    }
    NSString *productIds = [productIdArr componentsJoinedByString:@","];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 [_sellingType isEqualToString:@"yes"] ? @"remove" : @"add", @"action",
                                 productIds, @"productId",
                                 nil];
    NSLog(@"%@", dict);
    WS(weakSelf);
    _submitTask = [NetService POST:@"api/Store/ManageProShelves" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            [Utility showString:Localized(@"操作成功") onView:weakSelf.view];
            [weakSelf startHeardRefresh];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:weakSelf.view forTask:_submitTask];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSellingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreSellingCell" forIndexPath:indexPath];
//    cell.delegate = self;
    [cell setContentWithSellingProductModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
