//
//  GoodsCategoryViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "GoodsCategoryViewController.h"
#import "PYSearch.h"
#import "GoodsViewController.h"
#import "AddressPickerView.h"
#import "RightCell.h"
#import "CollectionSectionHeaderView.h"
#import "LeftCell.h"
#import "NetService.h"
#import "GoodsCategoryModel.h"

@interface GoodsCategoryViewController () <UISearchBarDelegate, PYSearchViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSURLSessionTask *_task;
}
@property (strong, nonatomic) UISearchBar *topSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;

@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSArray *subCategories;

//@property (weak, nonatomic) GoodsViewController *goodsVC;
@end

#define kColunm 3 //3列
#define kInterSpace 0.5 //列间距
#define kLeftSpace 10.0 //左右缩进
#define kLineSpace 0.5 //行间距

@implementation GoodsCategoryViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"Goods category dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _categories = [NSMutableArray array];
//    _collectionArray = [NSMutableArray array];
    [self initNavigationItem];
    
    [_leftTableView registerNib:[UINib nibWithNibName:@"LeftCell" bundle:nil] forCellReuseIdentifier:@"LeftCell"];
    UIButton *collectionHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionHeader.frame = CGRectMake(kLeftSpace, -((_rightCollectionView.frame.size.width-kLeftSpace*2)*9/28), kScreenWidth/4*3-kLeftSpace*2, (_rightCollectionView.frame.size.width-kLeftSpace*2)*9/28);
    [collectionHeader setImage:[UIImage imageNamed:@"fenlei_banner"] forState:UIControlStateNormal];
    [_rightCollectionView addSubview:collectionHeader];
    
    _rightCollectionView.contentInset = UIEdgeInsetsMake((_rightCollectionView.frame.size.width-kLeftSpace*2)*9/28 + 10, 0, 10, 0);
    [_rightCollectionView registerNib:[UINib nibWithNibName:@"RightCell" bundle:nil] forCellWithReuseIdentifier:@"RightCell"];
    [_rightCollectionView registerNib:[UINib nibWithNibName:@"CollectionSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionSectionHeaderView"];
    //导航栏透明，方式覆盖下方view
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self getAllCategory];
}

- (void)getAllCategory
{
    WS(weakSelf);
    _task = [NetService GET:@"api/Home/GetAllCategory" parameters:nil complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSArray *dataArray = responseObject[kResponseData];
            [weakSelf.categories removeAllObjects];
            for (NSDictionary *dict in dataArray) {
                GoodsCategoryModel *model = [[GoodsCategoryModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.categories addObject:model];
            }
            [weakSelf.leftTableView reloadData];
            if (!IS_NULL_ARRAY(weakSelf.categories)) {
                [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                GoodsCategoryModel *model = weakSelf.categories[0];
                if (model.hasChild) {
//                    [weakSelf.collectionArray removeAllObjects];
                    weakSelf.subCategories = model.subCategories;
                    [weakSelf.rightCollectionView reloadData];
                }
            }
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }

    }];
}

- (void)initNavigationItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"定位中") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 30)];
    _topSearchBar.delegate = self;
    _topSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    _topSearchBar.placeholder = Localized(@"搜索商品、店铺");
    UIImage *searchBackGround = [[UIImage imageNamed:@"searchbackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    [_topSearchBar setBackgroundImage:searchBackGround];
    
    self.navigationItem.titleView = _topSearchBar;
}

- (void)leftItemAction:(UIBarButtonItem *)item
{
    //TODO: left item touched
    NSLog(@"left item touched");
}

- (void)rightItemAction:(UIBarButtonItem *)item
{
    //TODO: right item touched
    NSLog(@"right item touched");
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self pushToSearchVCWithCategoryModel:nil andKeyWords:nil];
    return NO;
}

- (void)pushToSearchVCWithCategoryModel:(GoodsCategoryModel *)model andKeyWords:(NSString *)kw;
{
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    GoodsViewController *_goodsVC = [[GoodsViewController alloc] init];
    _goodsVC.isRequireRefreshHeader = YES;
    _goodsVC.isRequireRefreshFooter = YES;
    _goodsVC.delay = model?NO:YES;//延迟加载数据
    _goodsVC.model = model;
    _goodsVC.kw = kw;
    // 2. 创建搜索控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索全部商品" toToResult:model?YES:NO andSearchResultController:_goodsVC andSearchBarText:model.categoryName];
    
    searchViewController.delegate = self;
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    //    searchViewController.goToSearchResult = YES;
    
    searchViewController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    [searchViewController.navigationController popViewControllerAnimated:YES];
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index searchText:(NSString *)searchText
{
    GoodsViewController *vc = (GoodsViewController *)searchViewController.searchResultController;
    vc.kw = searchText;
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    GoodsViewController *vc = (GoodsViewController *)searchViewController.searchResultController;
    vc.kw = searchText;
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText
{
    GoodsViewController *vc = (GoodsViewController *)searchViewController.searchResultController;
    vc.kw = searchText;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell" forIndexPath:indexPath];
    [cell setContentWithGoodsCategoryModel:self.categories[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCategoryModel *model = self.categories[indexPath.row];
    if (model.hasChild) {
        self.subCategories = model.subCategories;
        [self.rightCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subCategories.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCell" forIndexPath:indexPath];
    [cell setContentWithGoodsCategoryModel:self.subCategories[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionSectionHeaderView" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - kInterSpace*(kColunm-1) - kLeftSpace * 2)/kColunm;
    return CGSizeMake(width, width/7*4 + 3 + 17);
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCategoryModel *model = self.subCategories[indexPath.row];
    
    [self pushToSearchVCWithCategoryModel:model andKeyWords:nil];
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
