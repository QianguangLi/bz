//
//  FirstPageViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "FirstPageViewController.h"
#import "LocationService.h"
#import "UserLocationModel.h"
#import "PYSearch.h"
#import "LoginViewController.h"
#import "GoodsViewController.h"

@interface FirstPageViewController () <UISearchBarDelegate, PYSearchViewControllerDelegate>

@property (strong, nonatomic) UISearchBar *topSearchBar;

@end

@implementation FirstPageViewController

- (void)dealloc
{
    NSLog(@"first page dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserLocation) name:kLocateUserSuccessNotification object:nil];
    
    [self initNavigationItem];
    [self refreshUserLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = kPinkColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}

- (void)initNavigationItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"定位中") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 44)];
    _topSearchBar.delegate = self;
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

- (void)refreshUserLocation
{
    UserLocationModel *model = [Utility getUserLocationInformation];
    if (model) {
        [self.navigationItem.rightBarButtonItem setTitle:model.city];
    }
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

#pragma mark

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
