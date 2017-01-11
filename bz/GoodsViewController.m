//
//  GoodsViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCell.h"
#import "NetService.h"
#import "ProductModel.h"

@interface GoodsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSURLSessionTask *_task;
}
@property (assign, nonatomic) BOOL isUp;

@end
//上次偏移量
static CGFloat previousOffsetY = 0.f;

@implementation GoodsViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"GoodsViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor redColor];
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellReuseIdentifier:@"GoodsCell"];
    
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    WS(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                 StringFromNumber(weakSelf.pageSize), kPageSize,
                                 @"", @"categoryId",
                                 @"", @"kw",
                                 nil];
    _task = [NetService POST:@"/api/Home/CategoryList" parameters:dict complete:^(id responseObject, NSError *error) {
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
            for (NSDictionary *dict in listArray) {
                ProductModel *model = [[ProductModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mTableView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth*100.0/320.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    WS(weakSelf);
    if (currentPostion - previousOffsetY > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight);
        }];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if ((previousOffsetY - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
    {
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        }];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark -
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
