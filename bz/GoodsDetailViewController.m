//
//  GoodsDetailViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ProductModel.h"
#import "CommentModel.h"
#import "NetService.h"
#import "UIView+Addition.h"
#import "JXButton.h"
#import "UIImageView+AFNetworking.h"
#import "CommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ChooseGoodsPropertyViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "ShoppingCartViewController.h"

@interface GoodsDetailViewController () <UITableViewDelegate, UITableViewDataSource, ChooseGoodsPropertyViewControllerDelegate>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_commentTask;
    NSURLSessionTask *_storeTask;
}
#pragma mark - 商品详情
@property (weak, nonatomic) IBOutlet UIImageView *proImageView;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pvLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressLabel;
#pragma mark - 请选择商品
@property (weak, nonatomic) IBOutlet UIButton *selectProductButton;
#pragma mark - 卖家信息
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
#pragma mark - 评论区
@property (weak, nonatomic) IBOutlet UIButton *allCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *badCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageCommentBtn;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *noneComment;

@property (strong, nonatomic) NSArray *commentArray;//评论数组

@property (nonatomic,strong) ChooseGoodsPropertyViewController *chooseVC;

@property (strong, nonatomic) ProductModel *productDetailModel;//商品model，具备更详细的数据

@property (assign, nonatomic) BOOL canSelect;//是否可以去选择商品

@end

@implementation GoodsDetailViewController

- (void)dealloc
{
    [_commentTask cancel];
    [_task cancel];
    [_storeTask cancel];
    NSLog(@"GoodsDetailViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _productModel.pName;
    [self getProductDetais];
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    [_commentTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [self getComment];
}

- (void)getComment
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _productModel.productId, @"productId",
                                 @"all", @"filter",
                                 @"0", kPageIndex,
                                 @"5", kPageSize,
                                 nil];
    WS(weakSelf);
    _commentTask = [NetService POST:@"api/Home/Comments" parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            CommentsModel *model = [[CommentsModel alloc] initWithDictionary:dataDict error:nil];
            [weakSelf reloadCommentViewWithCommentsModel:model];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0]] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//}

- (void)getProductDetais
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_productModel.productId, @"productId", nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Home/ProductDetails" parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            ProductModel *model = [[ProductModel alloc] initWithDictionary:dataDict error:nil];
            weakSelf.productDetailModel = model;
            weakSelf.canSelect = YES;
            [weakSelf reloadViewWithProductModel:model];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

- (void)reloadViewWithProductModel:(ProductModel *)model
{
    [_proImageView setImageWithURL:[NSURL URLWithString:model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _pName.text = model.pName;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    [_marketPriceLabel setStrikeLineText:[NSString stringWithFormat:@"  ￥%.2f  ", model.markprice]];
    _pvLabel.text = [NSString stringWithFormat:@"%.2f", model.pv];
    _expressLabel.text = model.shipping;
    
    [_storeLogoView setImageWithURL:[NSURL URLWithString:model.storelogo] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _storeNameLabel.text = model.storename;
}

- (void)reloadCommentViewWithCommentsModel:(CommentsModel *)model
{
    [_allCommentBtn setTitle:[NSString stringWithFormat:@"全部(%ld)", (long)model.allCount] forState:UIControlStateNormal];
    [_goodCommentBtn setTitle:[NSString stringWithFormat:@"好评(%ld)", (long)model.goodCount] forState:UIControlStateNormal];
    [_mediumCommentBtn setTitle:[NSString stringWithFormat:@"中评(%ld)", (long)model.mediumCount] forState:UIControlStateNormal];
    [_badCommentBtn setTitle:[NSString stringWithFormat:@"差评(%ld)", (long)model.badCount] forState:UIControlStateNormal];
    [_imageCommentBtn setTitle:[NSString stringWithFormat:@"有图(%ld)", (long)model.imageCount] forState:UIControlStateNormal];
    
    //刷新评论区
    _commentArray = model.comments;
    [_commentTableView reloadData];
    if (IS_NULL_ARRAY(model.comments)) {
        _noneComment.hidden = NO;
        _commentTableView.hidden = YES;
        
        _commentHeightLayout.constant = 80;
    } else {
        _noneComment.hidden = YES;
        _commentTableView.hidden = NO;
        
        _commentHeightLayout.constant = _commentTableView.contentSize.height;
    }
}

#pragma mark - ChooseGoodsPropertyViewControllerDelegate
- (void)chooseGoodsPropertyViewControllerDidSelectedProductDetailModel:(ProductDetailModel *)model
{
    if (model) {
        [_selectProductButton setTitle:[NSString stringWithFormat:@"已选:%@", model.propertyname] forState:UIControlStateNormal];
    } else {
        [_selectProductButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    [cell setContentWithCommentModel:_commentArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"CommentCell" cacheByIndexPath:indexPath configuration:^(CommentCell *cell) {
        [cell setContentWithCommentModel:_commentArray[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - 选择商品
- (IBAction)selectProductAction:(UIButton *)sender
{
    //如果未登录，先登录
    if (!kIsLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNvc animated:YES completion:^{
            
        }];
        return;
    }
    //数据没有加载完成不能取选择商品
    if (!_canSelect) {
        return;
    }
    if (!_chooseVC)
    {
        _chooseVC = [[ChooseGoodsPropertyViewController alloc] init];
    }
    _chooseVC.enterType = FirstEnterType;
    _chooseVC.model = _productDetailModel;
    _chooseVC.delegate = self;
//    self.chooseVC.price = 256.0f;
    [self.navigationController presentSemiViewController:_chooseVC withOptions:@{
                                                                                     KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                                     KNSemiModalOptionKeys.animationDuration : @(0.25),
                                                                                     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                                     KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]]
                                                                                     }];
}

#pragma mark - 进店逛逛
- (IBAction)entryStore:(UIButton *)sender {
}
#pragma mark - 关注店铺
- (IBAction)followStore:(UIButton *)sender {
}

#pragma mark - 商品评价
- (IBAction)commentBtnAction:(UIButton *)sender
{
    
}

#pragma mark - 底部按钮操作
- (IBAction)buy:(UIButton *)sender
{
//    [self selectProductAction:sender];
}

- (IBAction)addToShoppingCart:(UIButton *)sender
{
    [self selectProductAction:sender];
}

- (IBAction)goToShoppingCart:(JXButton *)sender
{
    //如果未登录，先登录
    if (!kIsLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNvc animated:YES completion:^{
            
        }];
        return;
    }
    ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
    vc.title = Localized(@"购物车");
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //改变返回按钮文字
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

//收藏商品   联系客服改成了收藏商品
- (IBAction)contactService:(JXButton *)sender
{
    //如果未登录，先登录
    if (!kIsLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNvc animated:YES completion:^{
            
        }];
        return;
    }
    [self storeGoodsWithProductIds:_productModel.productId];
}

#pragma mark - 收藏商品
- (void)storeGoodsWithProductIds:(NSString *)productIds
{
    if (IS_NULL_STRING(productIds)) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 productIds, @"productId",
                                 nil];
    [_storeTask cancel];
    WS(weakSelf);
    _storeTask = [NetService POST:@"api/User/AddFav" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            [Utility showString:Localized(@"收藏成功") onView:weakSelf.view];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_storeTask];
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
