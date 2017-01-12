//
//  ShoppingCartViewController.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "NetService.h"
#import "ShoppingCartModel.h"
#import "ProductModel.h"
#import "ShoppingCartCell.h"
#import "UIImageView+AFNetworking.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate, ShoppingCartCellDelegate>
{
    NSURLSessionTask *_task;
}

@property (nonatomic,strong) UIButton *rightButton;
//@property (nonatomic,strong) ChooseGoodsPropertyViewController *chooseVC;
// 由于代理问题衍生出的来已经选择单个或者批量的数组装Cell
@property (nonatomic,strong) NSMutableArray *tempCellArray;



// 底部统计View的控件 （normal）
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
@property (weak, nonatomic) IBOutlet UIView *normalBottomRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalBottomRightWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

// 底部全局编辑按钮 (edit)
@property (weak, nonatomic) IBOutlet UIView *editBottomRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBottomRightWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *editBaby;
@property (weak, nonatomic) IBOutlet UIButton *bottomDelete;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;


// footerView
@property (strong, nonatomic) IBOutlet UIView *underFooterView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *relatedProducts; // 底部相关商品


@property (nonatomic,strong) UIView *textView;
@end

static NSString *shoppongID = @"ShoppingCartCell";
static NSString *shoppingHeaderID = @"BuyerHeaderCell";
@implementation ShoppingCartViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 44 - 50);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.sectionFooterHeight = 5;
    self.mTableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置底部按钮
    CGRect rec = self.bottomView.frame;
    rec.size.width = [UIScreen mainScreen].bounds.size.width;
    rec.size.height = 50;
    rec.origin.x = 0;
    rec.origin.y = kScreenHeight - 49 - 50;
    self.bottomView.frame = rec;
    self.normalBottomRightWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 2 / 3;
    self.editBottomRightWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 2 / 3;
    [self.view addSubview:self.bottomView];
    self.editBottomRightView.hidden = YES;
    
    
    // 右上角编辑
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [self.rightButton setTitle:@"编辑" forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    [self.rightButton addTarget:self action:@selector(clickAllEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *batbutton = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = batbutton;
    
    
    [self.mTableView registerNib:[UINib nibWithNibName:shoppongID bundle:nil] forCellReuseIdentifier:shoppongID];
    [self.mTableView registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil] forCellReuseIdentifier:shoppingHeaderID];
    
}

#pragma mark - 点击全部编辑按钮
- (void)clickAllEdit:(UIButton *)button
{
    button.selected = !button.selected;
    for (ShoppingCartModel *buyer in self.dataArray)
    {
        buyer.buyerIsEditing = button.selected;
    }
    [self.mTableView reloadData];
    self.editBottomRightView.hidden = !button.selected;
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    self.totalPriceLabel.text = @"合计￥0.00";
    self.allSelectedButton.selected = NO;
    self.rightButton.selected = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/User/ShoppingCart" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
//            weakSelf.pageCount = [dataDict[kPageCount] integerValue];
            NSArray *listArray = dataDict[@"list"];
            if (pullDown) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in listArray) {
                ShoppingCartModel *model = [[ShoppingCartModel alloc] initWithDictionary:dict error:nil];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShoppingCartModel *buyer = self.dataArray[section];
    return buyer.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppongID forIndexPath:indexPath];
    
    cell.delegate = self;
    [self configCell:cell indexPath:indexPath];
    
    return cell;
}

// 组装cell
- (void)configCell:(ShoppingCartCell *)cell indexPath:(NSIndexPath *)indexPath
{
    ShoppingCartModel *buyer = self.dataArray[indexPath.section];
    ProductModel *product = buyer.products[indexPath.row];
    cell.leftChooseButton.selected = product.productIsChoosed; //!< 商品是否需要选择的字段
    [cell.productImageView setImageWithURL:[NSURL URLWithString:product.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    
    cell.titleLabel.text = product.pName;
//    if (IS_NULL_ARRAY(product.model_detail))
//    {
//        cell.sizeDetailLabel.text = @"";
//        cell.editDetailView.hidden = YES;
//    }
//    else
//    {
//        cell.editDetailView.hidden = NO;
//        cell.sizeDetailLabel.text = @"这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据";
//        cell.editDetailTitleLabel.text = @"点击我修改规格";
//    }
    cell.editDetailView.hidden = NO;
    cell.sizeDetailLabel.text = product.propertyd;
    cell.editDetailTitleLabel.text = @"点击我修改规格";
    
    cell.priceLabel.attributedText = [Utility recombinePrice:product.price orderPrice:product.pv];
    
    cell.countLabel.text = [NSString stringWithFormat:@"x%ld",product.quantity];
    
    cell.editCountLabel.text = [NSString stringWithFormat:@"%ld",product.quantity];
    
    
    // 正常模式下面 非编辑
    if (!buyer.buyerIsEditing)
    {
        cell.normalBackView.hidden = NO;
        cell.editBackView.hidden = YES;
    }
    else
    {
        cell.normalBackView.hidden = YES;
        cell.editBackView.hidden = NO;
    }
}

// 高度计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartModel *buyer = self.dataArray[indexPath.section];
    if (buyer.buyerIsEditing)
    {
        return 100;
    }
    else
    {
        CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:shoppongID cacheByIndexPath:indexPath configuration:^(ShoppingCartCell *cell) {
            
            [self configCell:cell indexPath:indexPath];
            
        }];
        return actualHeight >= 100 ? actualHeight : 100;
    }
}

// tableView的sectionHeader加载数据
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingCartModel *buyer = self.dataArray[section];
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingHeaderID];
    cell.headerSelectedButton.selected = buyer.buyerIsChoosed; //!< 买手是否需要勾选的字段
    [cell.buyerImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"member-head"]];
    cell.buyerNameLabel.text = buyer.storename;
    cell.sectionIndex = section;
    cell.editSectionHeaderButton.selected = buyer.buyerIsEditing;
    if (self.rightButton.selected)
    {
        cell.editSectionHeaderButton.hidden = YES;
    }
    else
    {
        cell.editSectionHeaderButton.hidden = NO;
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma - 点击单个商品cell选择按钮
- (void)productSelected:(ShoppingCartCell *)cell isSelected:(BOOL)choosed
{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
    ShoppingCartModel *buyer  = self.dataArray[indexPath.section];
    ProductModel *product = buyer.products[indexPath.row];
    product.productIsChoosed = !product.productIsChoosed;
    // 当点击单个的时候，判断是否该买手下面的商品是否全部选中
    __block NSInteger count = 0;
    [buyer.products enumerateObjectsUsingBlock:^(ProductModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.productIsChoosed)
        {
            count ++;
        }
    }];
    if (count == buyer.products.count)
    {
        buyer.buyerIsChoosed = YES;
    }
    else
    {
        buyer.buyerIsChoosed = NO;
    }
    [self.mTableView reloadData];
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
}


#pragma mark - 点击buer选择按钮回调
- (void)buyerSelected:(NSInteger)sectionIndex
{
    ShoppingCartModel *buyer = self.dataArray[sectionIndex];
    buyer.buyerIsChoosed = !buyer.buyerIsChoosed;
    [buyer.products enumerateObjectsUsingBlock:^(ProductModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.productIsChoosed = buyer.buyerIsChoosed;
    }];
    [self.mTableView reloadData];
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
}

#pragma mark - 点击buyer编辑按钮回调
- (void)buyerEditingSelected:(NSInteger)sectionIdx
{
    ShoppingCartModel *buy = self.dataArray[sectionIdx];
    buy.buyerIsEditing = !buy.buyerIsEditing;
    [self.mTableView reloadData];
}

#pragma mark - 点击编辑详情回调
- (void)clickEditingDetailInfo:(ShoppingCartCell *)cell
{
    // 编辑对应的商品信息，这里写的太多了，我就写死了，逻辑太多了，这尼玛根本不叫Demo了，这简直就是我的成品
//    self.chooseVC = nil;
//    self.chooseVC = [[ChooseGoodsPropertyViewController alloc] init];
//    self.chooseVC.enterType = SecondEnterType;
//    self.chooseVC.price = 999.99f;
//    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{
//                                                                                     KNSemiModalOptionKeys.pushParentBack    : @(YES),
//                                                                                     KNSemiModalOptionKeys.animationDuration : @(0.6),
//                                                                                     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
//                                                                                     KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]]
//                                                                                     }];
}


#pragma mark - 点击图片展示Show
- (void)clickProductIMG:(ShoppingCartCell *)cell
{
    NSIndexPath *indexpath = [self.mTableView indexPathForCell:cell];
    ShoppingCartModel *buyer = self.dataArray[indexpath.section];
    ProductModel *product = buyer.products[indexpath.row];
    NSLog(@"商品名称:%@", product.pName);
}

#pragma mark -增加或者减少商品
- (void)plusOrMinusCount:(ShoppingCartCell *)cell tag:(NSInteger)tag
{
    NSIndexPath *indexpath = [self.mTableView indexPathForCell:cell];
    ShoppingCartModel *buyer = self.dataArray[indexpath.section];
    ProductModel *product = buyer.products[indexpath.row];
    
    if (tag == 555)
    {
        if (product.quantity <= 1) {
            
        }
        else
        {
            product.quantity --;
        }
    }
    else if (tag == 666)
    {
        product.quantity ++;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    [self.mTableView reloadData];
}

#pragma mark - 点击单个商品删除回调
- (void)productGarbageClick:(ShoppingCartCell *)cell
{
    [self.tempCellArray removeAllObjects];
    [self.tempCellArray addObject:cell];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    alert.delegate = self;
    [alert show];
}

// alert的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 单个删除
    if (alertView.tag == 101) {
        if (buttonIndex == 1)
        {
            NSIndexPath *indexpath = [self.mTableView indexPathForCell:self.tempCellArray.firstObject];
            ShoppingCartModel *buyer = self.dataArray[indexpath.section];
            ProductModel *product = buyer.products[indexpath.row];
            if (buyer.products.count == 1) {
                [self.dataArray removeObject:buyer];
            }
            else
            {
                [buyer.products removeObject:product];
            }
            // 这里删除之后操作涉及到太多东西了，需要
            [self updateInfomation];
        }
    }
    else if (alertView.tag == 102) // 多个或者单个
    {
        if (buttonIndex == 1)
        {
            NSMutableArray *buyerTempArr = [[NSMutableArray alloc] init];
            for (ShoppingCartModel *buyer in self.dataArray)
            {
                if (buyer.buyerIsChoosed)
                {
                    [buyerTempArr addObject:buyer];
                }
                else
                {
                    NSMutableArray *productTempArr = [[NSMutableArray alloc] init];
                    for (ProductModel *product in buyer.products)
                    {
                        if (product.productIsChoosed)
                        {
                            [productTempArr addObject:product];
                        }
                    }
                    if (!IS_NULL_ARRAY(buyerTempArr))
                    {
                        [buyer.products removeObjectsInArray:productTempArr];
                    }
                }
            }
            [self.dataArray removeObjectsInArray:buyerTempArr];
            [self updateInfomation];
        }
    }
    
}

#pragma mark - 删除之后一些列更新操作
- (void)updateInfomation
{
    // 会影响到对应的买手选择
    for (ShoppingCartModel *buyer in self.dataArray) {
        NSInteger count = 0;
        for (ProductModel *product in buyer.products) {
            if (product.productIsChoosed) {
                count ++;
            }
        }
        if (count == buyer.products.count) {
            buyer.buyerIsChoosed = YES;
        }
    }
    // 再次影响到全部选择按钮
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    [self.mTableView reloadData];
    
    // 如果删除干净了
    if (IS_NULL_ARRAY(self.dataArray)) {
        [self clickAllEdit:self.rightButton];
        self.rightButton.enabled = NO;
    }
    
    
}


#pragma mark - 判断是否全部选中了
- (BOOL)isAllProcductChoosed
{
    if (IS_NULL_ARRAY(self.dataArray)) {
        return NO;
    }
    NSInteger count = 0;
    for (ShoppingCartModel *buyer in self.dataArray) {
        if (buyer.buyerIsChoosed) {
            count ++;
        }
    }
    return (count == self.dataArray.count);
}

#pragma mark - 点击底部全选按钮
- (IBAction)clickAllProductSelected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    for (ShoppingCartModel *buyer in self.dataArray) {
        buyer.buyerIsChoosed = sender.selected;
        for (ProductModel *product in buyer.products) {
            product.productIsChoosed = buyer.buyerIsChoosed;
        }
    }
    [self.mTableView reloadData];
    
    CGFloat totalPrice = [self countTotalPrice];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",totalPrice];
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
}


#pragma -
#pragma mark - 计算选出商品的总价
- (CGFloat)countTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (ShoppingCartModel *buyer in self.dataArray) {
        if (buyer.buyerIsChoosed) {
            for (ProductModel *product in buyer.products) {
                totalPrice += product.price * product.quantity;
            }
        }else{
            for (ProductModel *product in buyer.products) {
                if (product.productIsChoosed) {
                    totalPrice += product.price * product.quantity;
                }
            }
            
        }
    }
    return totalPrice;
}

#pragma mark - 计算商品被选择了数量
- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
    for (ShoppingCartModel *buyer in self.dataArray) {
        for (ProductModel *product in buyer.products) {
            if (product.productIsChoosed) {
                count ++;
            }
        }
    }
    return count;
}

// 分享
- (IBAction)share:(id)sender {
    NSLog(@"分享宝贝");
}

// 移动到收藏夹
- (IBAction)store:(id)sender {
    NSLog(@"移动到收藏夹");
}

// 底部多选删除也可单选删除
- (IBAction)deleteMultipleOrSingfle:(id)sender {
    
    // 这个大的是用来过滤buyer的 没有就是nil，从商品数组中删除
    [self.tempCellArray removeAllObjects];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    alert.delegate = self;
    [alert show];
}

- (NSMutableArray *)tempCellArray
{
    if (_tempCellArray == nil) {
        _tempCellArray = [[NSMutableArray alloc] init];
    }
    return _tempCellArray;
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
