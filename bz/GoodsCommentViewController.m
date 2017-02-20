//
//  GoodsCommentViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GoodsCommentViewController.h"
#import "ImageCollectionCell.h"
#import "CommentHeaderView.h"
#import "UIView+Addition.h"
#import "NetService.h"
#import "CommentModel.h"

#define kColunm 3 //3列
#define kInterSpace 5.0 //列间距
#define kLeftSpace 8.0 //左右缩进
#define kLineSpace 5 //列间距

@interface GoodsCommentViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSURLSessionTask *_task;
}
@property (weak, nonatomic) IBOutlet UIButton *allCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *badCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageCommentBtn;

@property (copy, nonatomic) NSString *filter;//all全部good好评medium中评bad差评image有图


@property (weak, nonatomic) IBOutlet UIView *secondNavigation;

@end

@implementation GoodsCommentViewController

- (void)viewDidLoad {
    //初始化默认全部
    _filter = @"all";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"商品评价");
    [self setupCommentButton];
    self.mCollectionView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-64-44);
//    self.mCollectionView.backgroundColor = [UIColor whiteColor];
    self.mCollectionView.contentInset = UIEdgeInsetsZero;
    self.mCollectionView.delegate = self;
    self.mCollectionView.dataSource = self;

    [self.mCollectionView registerNib:[UINib nibWithNibName:@"CommentHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CommentHeaderView"];
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"CommentFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CommentFooterView"];
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionCell"];
}

- (void)setupCommentButton
{
    [_allCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_allCommentBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    [_goodCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_goodCommentBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    [_mediumCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_mediumCommentBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    [_badCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_badCommentBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    [_imageCommentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_imageCommentBtn setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateSelected];
    
    _allCommentBtn.selected = YES;
}

- (IBAction)commentBtnAction:(UIButton *)sender
{
    for (int i = 100; i < 105; i++) {
        UIButton *btn = [_secondNavigation viewWithTag:i];
        btn.selected = NO;
    }
    NSInteger tag = sender.tag;
    if (tag == 100) {
        _filter = @"all";
    } else if (tag == 101) {
        _filter = @"good";
    } else if (tag == 102) {
        _filter = @"medium";
    } else if (tag == 103) {
        _filter = @"bad";
    } else if (tag == 104) {
        _filter = @"image";
    }
    sender.selected = YES;
    
    [self.dataArray removeAllObjects];
    [self.mCollectionView reloadData];
    [self startRequest];
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _productId, @"productId",
                                 _filter, @"filter",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(self.pageSize), kPageSize,
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Home/Comments" parameters:dict complete:^(id responseObject, NSError *error) {
        endRefreshing(error);
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
            [weakSelf showTipWithNoData:IS_NULL_ARRAY(weakSelf.dataArray)];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
}

- (void)reloadCommentViewWithCommentsModel:(CommentsModel *)model
{
    [_allCommentBtn setTitle:[NSString stringWithFormat:@"全部(%ld)", (long)model.allCount] forState:UIControlStateNormal];
    [_goodCommentBtn setTitle:[NSString stringWithFormat:@"好评(%ld)", (long)model.goodCount] forState:UIControlStateNormal];
    [_mediumCommentBtn setTitle:[NSString stringWithFormat:@"中评(%ld)", (long)model.mediumCount] forState:UIControlStateNormal];
    [_badCommentBtn setTitle:[NSString stringWithFormat:@"差评(%ld)", (long)model.badCount] forState:UIControlStateNormal];
    [_imageCommentBtn setTitle:[NSString stringWithFormat:@"有图(%ld)", (long)model.imageCount] forState:UIControlStateNormal];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:model.comments];
    [self.mCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CommentModel *commentModel = self.dataArray[section];
    return commentModel.images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionCell" forIndexPath:indexPath];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *commentModel = self.dataArray[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CommentHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CommentHeaderView" forIndexPath:indexPath];
        [headerView setContentWithCommentModel:commentModel];
        return headerView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        CommentHeaderView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CommentFooterView" forIndexPath:indexPath];
        [footerView setContentWithCommentModel:commentModel];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - kInterSpace*(kColunm-1) - kLeftSpace * 2)/kColunm;
    return CGSizeMake(width, width);
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
    CommentModel *model = self.dataArray[section];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 8 * 2, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return CGSizeMake(collectionView.frame.size.width, 55+rect.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
