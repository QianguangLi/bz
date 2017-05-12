//
//  AlwaysBuyViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/9.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AlwaysBuyViewController.h"
#import "MJRefresh.h"
#import "NetService.h"
#import "AlwaysBuyCell.h"
#import "ProductModel.h"

#define kColunm 2 //3列
#define kInterSpace 5.0 //列间距
#define kLeftSpace 0.0 //左右缩进
#define kLineSpace 5 //列间距

@interface AlwaysBuyViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSURLSessionTask *_task;
}

@end

@implementation AlwaysBuyViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"常购清单");
    
    self.mCollectionView.backgroundColor = QGCOLOR(238, 238, 239, 1);
    self.mCollectionView.delegate = self;
    self.mCollectionView.dataSource = self;
    self.mCollectionView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"AlwaysBuyCell" bundle:nil] forCellWithReuseIdentifier:@"AlwaysBuyCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/User/PurchaseList" parameters:dict complete:^(id responseObject, NSError *error) {
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
                ProductModel *model = [[ProductModel alloc] initWithDictionary:orderDict error:nil];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mCollectionView reloadData];
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlwaysBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlwaysBuyCell" forIndexPath:indexPath];
    [cell setContentWithProductModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - kInterSpace*(kColunm-1) - kLeftSpace * 2)/kColunm;
    return CGSizeMake(width, width + 31.5 + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kLeftSpace, 0, kLeftSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //行间距
    return kLineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //列间距
    return kInterSpace;
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
