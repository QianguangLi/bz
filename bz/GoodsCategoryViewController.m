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

@interface GoodsCategoryViewController () <UISearchBarDelegate, PYSearchViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UISearchBar *topSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;

@end

#define kColunm 3 //3列
#define kInterSpace 0.5 //列间距
#define kLeftSpace 10.0 //左右缩进

@implementation GoodsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. 创建搜索控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索全部商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始(点击)搜索时执行以下代码
        // 如：跳转到指定控制器
        //        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];
    searchViewController.delegate = self;
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    GoodsViewController *goodsVC = [[GoodsViewController alloc] init];
    searchViewController.searchResultController = goodsVC;
    // 3. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}

#pragma mark - PYSearchViewControllerDelegate
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    [searchViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCell" forIndexPath:indexPath];
    
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
    return 0.5;
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
