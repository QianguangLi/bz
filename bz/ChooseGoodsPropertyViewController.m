//
//  ChooseGoodsPropertyViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ChooseGoodsPropertyViewController.h"
#import "GoodsPropertyCell.h"
#import "CollectionSectionHeaderView.h"
#import "UIImageView+AFNetworking.h"

#define kColunm 3 //3列
#define kInterSpace 10 //列间距
#define kLeftSpace 10.0 //左右缩进
#define kLineSpace 5 //行间距

@interface ChooseGoodsPropertyViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CountCollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *alreadySelectLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *propertyCollectionView;

@property (strong, nonatomic) NSArray *propertyArray;//属性数组
@property (strong, nonatomic) NSArray *pDetailArray;//子商品数组

@end

@implementation ChooseGoodsPropertyViewController

- (void)dealloc
{
    NSLog(@"ChooseGoodsPropertyViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_propertyCollectionView registerNib:[UINib nibWithNibName:@"GoodsPropertyCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsPropertyCell"];
    [_propertyCollectionView registerNib:[UINib nibWithNibName:@"CountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CountCollectionCell"];
    [_propertyCollectionView registerNib:[UINib nibWithNibName:@"CollectionSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionSectionHeaderView"];
    _propertyCollectionView.allowsMultipleSelection = YES;
    NSLog(@"%@", _model);
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", _model.price];
    [_goodsImageView setImageWithURL:[NSURL URLWithString:_model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
    _propertyArray = _model.propertylist;
    _pDetailArray = _model.pdetaillist;
}

#pragma mark - 底部按钮点击事件
- (IBAction)addToShoppingCart:(UIButton *)sender
{
    if (_propertyCollectionView.indexPathsForSelectedItems.count != _propertyArray.count) {
        [Utility showString:Localized(@"请选择商品属性") onView:self.view];
        return;
    }
}

- (IBAction)buy:(UIButton *)sender
{
    if (_propertyCollectionView.indexPathsForSelectedItems.count != _propertyArray.count) {
        [Utility showString:Localized(@"请选择商品属性") onView:self.view];
        return;
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == _propertyArray.count) {
        return 1;
    }
    PropertysModel *propertysModel = _propertyArray[section];
    return propertysModel.propertyid.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _propertyArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = nil;
    if (indexPath.section == _propertyArray.count) {
        ID = @"CountCollectionCell";
        GoodsPropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.countDelegate = self;
        return cell;
    } else {
        ID = @"GoodsPropertyCell";
        GoodsPropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        PropertysModel *propertysModel = _propertyArray[indexPath.section];
        PropertyModel *propertyModel = propertysModel.propertyid[indexPath.row];
        cell.propertyLabel.text = propertyModel.propertyName;
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionSectionHeaderView" forIndexPath:indexPath];
        if (indexPath.section == _propertyArray.count) {
            headerView.categoryName.text = Localized(@"购买数量");
            headerView.rightButton.hidden = YES;
        } else {
            PropertysModel *propertysModel = _propertyArray[indexPath.section];
            headerView.categoryName.text = propertysModel.propertyname;
            headerView.rightButton.hidden = YES;
        }
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _propertyArray.count) {
        return CGSizeMake(_propertyCollectionView.frame.size.width - kLeftSpace *2, 44);
    }
    PropertysModel *propertysModel = _propertyArray[indexPath.section];
    PropertyModel *propertyModel = propertysModel.propertyid[indexPath.row];
    NSString *str = propertyModel.propertyName;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(_propertyCollectionView.frame.size.width - kLeftSpace * 2, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    rect.size.width = rect.size.width + 10 < 60 ? 60 : rect.size.width + 10;
    rect.size.height = rect.size.height + 10 + 10;
    return rect.size;
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadWithProductDetailModel:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != _propertyArray.count) {
        NSArray *selectedItems = collectionView.indexPathsForSelectedItems;
        for (NSIndexPath *index in selectedItems) {
            //多选状态，控制section内单选
            if (index.section == indexPath.section && index.row != indexPath.row) {
                [collectionView deselectItemAtIndexPath:index animated:YES];
            }
        }
        //根据选中条件计算价格
        NSArray *arr = collectionView.indexPathsForSelectedItems;
        //根据 indexPath.section排序
        NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath  * _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
            if (obj1.section <= obj2.section) {
                return NSOrderedAscending;
            } else {
                return  NSOrderedDescending;
            }
        }];
        //制作属性id数组
        NSMutableArray *propertyIdArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in sortedArr) {
            PropertysModel *propertysModel = _propertyArray[indexPath.section];
            PropertyModel *propertyModel = propertysModel.propertyid[indexPath.row];
            [propertyIdArray addObject:propertyModel.propertyId];
        }
        NSString *propertyIdStr = [propertyIdArray componentsJoinedByString:@"-"];
        [self searchProductDetailWith:propertyIdStr];
    }
}

#pragma mark - CountCollectionCellDelegate
- (void)numberOfBuyGoods:(int)numberOfBuyGoods
{
    NSLog(@"购买数量%d", numberOfBuyGoods);
}

#pragma mark - 根据选择条件刷新页面
- (void)searchProductDetailWith:(NSString *)propertyIdStr
{
    for (ProductDetailModel *productDetailModel in _pDetailArray) {
        if ([productDetailModel.propertyid isEqualToString:propertyIdStr]) {
            [self reloadWithProductDetailModel:productDetailModel];
            return;
        }
    }
}

- (void)reloadWithProductDetailModel:(ProductDetailModel *)productDetailModel
{
    if (productDetailModel) {
        [_goodsImageView setImageWithURL:[NSURL URLWithString:productDetailModel.pdetailimg] placeholderImage:[UIImage imageNamed:@"productpic"]];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", productDetailModel.price];
        _alreadySelectLabel.text = [NSString stringWithFormat:@"已选:%@", productDetailModel.propertyname];
    } else {
        [_goodsImageView setImageWithURL:[NSURL URLWithString:_model.pImgUrl] placeholderImage:[UIImage imageNamed:@"productpic"]];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", _model.price];
        _alreadySelectLabel.text = @"已选:";
    }
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
