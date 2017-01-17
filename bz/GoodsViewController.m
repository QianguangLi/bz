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
#import "YLButton.h"
#import "QGDropDownMenu.h"
#import "GoodsDetailViewController.h"

@interface GoodsViewController () <UITableViewDelegate, UITableViewDataSource, QGDropDownMenuDateSource, QGDropDownMenuDelegate>
{
    NSURLSessionTask *_task;
    NSURLSessionTask *_otherTask;
    
}

@property (strong, nonatomic) QGDropDownMenu *priceMenu;//价格排行
@property (strong, nonatomic) QGDropDownMenu *pinpaiMenu;//品牌
@property (strong, nonatomic) QGDropDownMenu *sellMenu;//销售排行
@property (assign, nonatomic) BOOL isUp;
@property (weak, nonatomic) IBOutlet UIView *secondNavigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secNavTopLayout;

@property (copy, nonatomic) NSString *order;//排序依据(default:默认sales:销量price:价格ontime:上架时间)
@property (copy, nonatomic) NSString *action;//排序动作(asc:升序desc:降序)
@property (copy, nonatomic) NSString *pinpaiCode;//品牌code


@property (strong, nonatomic) NSArray *priceArray;//价格排行数组
@property (strong, nonatomic) NSArray *sellArray;//销售排行数组
@property (strong, nonatomic) NSMutableArray *pinpaiArray;//品牌数组

@end
//上次偏移量
//static CGFloat previousOffsetY = 0.f;

@implementation GoodsViewController

- (void)dealloc
{
    [_task cancel];
    [_otherTask cancel];
    NSLog(@"GoodsViewController dealloc");
}

- (void)viewDidLoad {
    _pinpaiArray = [NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"-1", @"pinpaicode", @"商品品牌", @"pinpainame", nil];
    [self.pinpaiArray addObject:dict];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSecondNavigation];
    [self initView];
    
    _priceArray = [NSArray arrayWithObjects:@"价格", @"价格升序", @"价格降序", nil];
    _sellArray = [NSArray arrayWithObjects:@"销售排行", @"销售升序", @"销售降序", nil];
    
    [self.view bringSubviewToFront:self.secondNavigation];
    
}

- (void)initView
{
    self.mTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-64-44);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.contentInset = UIEdgeInsetsZero;
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"GoodsCell" bundle:nil] forCellReuseIdentifier:@"GoodsCell"];
}

- (void)initSecondNavigation
{
    //二级导航数据
    NSArray *contentArray = @[
                              @{@"title":Localized(@"价格")},
                              @{@"title":Localized(@"商品品牌")},
                              @{@"title":Localized(@"销售排行")},
                              @{@"title":Localized(@"筛选")},
                              ];
    //创建二级导航按钮
    for (int i = 0; i < contentArray.count; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth/contentArray.count * i, 0, kScreenWidth/contentArray.count, _secondNavigation.frame.size.height);
        [btn setTitle:contentArray[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:kPinkColor forState:UIControlStateSelected];
        [btn setTextRightImage:[UIImage imageNamed:@"more-gray"] forState:UIControlStateNormal];
        [btn setTextRightImage:[UIImage imageNamed:@"more-red"] forState:UIControlStateSelected];
        //设置tag为订单类型
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(secondNavigationAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondNavigation addSubview:btn];
    }
}

- (void)secondNavigationAction:(UIButton *)btn
{
    NSInteger tag = btn.tag - 100;
    if (tag == 0) {
        //价格排序
        if (_sellMenu) {
            [_sellMenu remove];
        }
        if (_pinpaiMenu) {
            [_pinpaiMenu remove];
        }
        if (_priceMenu) {
            [_priceMenu remove];
        } else {
            _priceMenu = [[QGDropDownMenu alloc] initWithOrigin:CGPointMake(0, CGRectGetMaxY(_secondNavigation.frame)) andWidth:kScreenWidth];
            _priceMenu.dateSource = self;
            _priceMenu.delegate = self;
            [self.view addSubview:_priceMenu];
            [_priceMenu reloadData];
        }
    } else if (tag == 1) {
        //商品品牌
        if (_sellMenu) {
            [_sellMenu remove];
        }
        if (_priceMenu) {
            [_priceMenu remove];
        }
        if (_pinpaiMenu) {
            [_pinpaiMenu remove];
        } else {
            if (IS_NULL_ARRAY(_pinpaiArray)) {
                return;
            }
            _pinpaiMenu = [[QGDropDownMenu alloc] initWithOrigin:CGPointMake(0, CGRectGetMaxY(_secondNavigation.frame)) andWidth:kScreenWidth];
            _pinpaiMenu.dateSource = self;
            _pinpaiMenu.delegate = self;
            [self.view addSubview:_pinpaiMenu];
            [_pinpaiMenu reloadData];
        }
    } else if (tag == 2) {
        //销售排行
        if (_priceMenu) {
            [_priceMenu remove];
        }
        if (_pinpaiMenu) {
            [_pinpaiMenu remove];
        }
        if (_sellMenu) {
            [_sellMenu remove];
        } else {
            _sellMenu = [[QGDropDownMenu alloc] initWithOrigin:CGPointMake(0, CGRectGetMaxY(_secondNavigation.frame)) andWidth:kScreenWidth];
            _sellMenu.dateSource = self;
            _sellMenu.delegate = self;
            [self.view addSubview:_sellMenu];
            [_sellMenu reloadData];
        }
    } else {
        //筛选
    }
}


- (void)setKw:(NSString *)kw
{
    _kw = kw;
    if (!IS_NULL_STRING(_kw)) {
        [self startRequest];
    }
}

- (void)setModel:(GoodsCategoryModel *)model
{
    _model = model;
}

- (void)requestDataListPullDown:(BOOL)pullDown andEndRefreshing:(EndRefreshing)endRefreshing
{
    
    if (_isFirstEntry) {
        [_task cancel];
        WS(weakSelf);
        _kw = IS_NULL_STRING(_kw)?@"":_kw;
        NSString *categoryId = IS_NULL_STRING(_model.categoryId) ? @"" : _model.categoryId;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                     StringFromNumber(weakSelf.pageSize), kPageSize,
                                     categoryId, @"categoryId",
                                     _kw, @"kw",
                                     nil];
        _task = [NetService POST:@"/api/Home/CategoryList" parameters:dict complete:^(id responseObject, NSError *error) {
            endRefreshing(error);
            _isFirstEntry = NO;
            if (error) {
                NSLog(@"failure:%@", error);
                [Utility showString:error.localizedDescription onView:weakSelf.view];
                return ;
            }
            NSLog(@"%@", responseObject);
            if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
                NSDictionary *dataDict = responseObject[kResponseData];
                //品牌数组
                NSArray *pArray = dataDict[@"pingpaiList"];
                if (!IS_NULL_ARRAY(pArray)) {
//                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"-1", @"pinpaicode", @"商品品牌", @"pinpainame", nil];
//                    [weakSelf.pinpaiArray addObject:dict];
                    [weakSelf.pinpaiArray addObjectsFromArray:pArray];
                }
                //商品字典
                NSDictionary *productInfo = dataDict[@"productInfo"];
                weakSelf.pageCount = [productInfo[kPageCount] integerValue];
                NSArray *listArray = productInfo[@"products"];
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
    } else {
        [_otherTask cancel];
        WS(weakSelf);
        //如果参数为空设置默认值
        _kw = IS_NULL_STRING(_kw)?@"":_kw;
        _order = IS_NULL_STRING(_order)?@"default":_order;
        _action = IS_NULL_STRING(_action)?@"":_action;
        _pinpaiCode = IS_NULL_STRING(_pinpaiCode)?@"-1":_pinpaiCode;
        NSString *categoryId = IS_NULL_STRING(_model.categoryId) ? @"" : _model.categoryId;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     StringFromNumber(weakSelf.pageIndex), kPageIndex,
                                     StringFromNumber(weakSelf.pageSize), kPageSize,
                                     _order, @"order",
                                     _action, @"action",
                                     _pinpaiCode, @"ppcode",
                                     categoryId, @"categoryId",
                                     _kw, @"kw",
                                     @"", @"startMoney",
                                     @"", @"endMoney",
                                     nil];
        _task = [NetService POST:@"api/Home/ProductsList" parameters:dict complete:^(id responseObject, NSError *error) {
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
                NSArray *listArray = dataDict[@"products"];
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
}

#pragma mark - QGDropDownMenuDateSource
- (NSInteger)numberOfRowsDropDownMenu:(QGDropDownMenu *)dropDownMenu
{
    if (dropDownMenu == _priceMenu) {
        return _priceArray.count;
    } else if (dropDownMenu == _sellMenu) {
        return _sellArray.count;
    } else if (dropDownMenu == _pinpaiMenu) {
        return _pinpaiArray.count;
    }
    return 0;
}

- (NSString *)dropDownMenu:(QGDropDownMenu *)dropDownMenu titleForRow:(NSInteger)row
{
    if (dropDownMenu == _priceMenu) {
        return _priceArray[row];
    } else if (dropDownMenu == _sellMenu) {
        return _sellArray[row];
    } else if (dropDownMenu == _pinpaiMenu) {
        return _pinpaiArray[row][@"pinpainame"];
    }
    return nil;
}

- (NSInteger)selectRowDropDownMenu:(QGDropDownMenu *)dropDownMenu
{
    if (dropDownMenu == _priceMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:100];
        return [_priceArray indexOfObject:btn.titleLabel.text];
    } else if (dropDownMenu == _sellMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:102];
        return [_sellArray indexOfObject:btn.titleLabel.text];
    } else if (dropDownMenu == _pinpaiMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:102];
        NSString *title = btn.titleLabel.text;
        for (int i = 0; i < _pinpaiArray.count; i++) {
            NSDictionary *dict = _pinpaiArray[i];
            if ([dict[@"pinpainame"] isEqualToString:title]) {
                return i;
            }
        }
    }
    return 0;
}

- (void)didRemoveForSuperViewDropDownMenu:(QGDropDownMenu *)dropDownMenu
{
    if (dropDownMenu == _priceMenu) {
        _priceMenu = nil;
    } else if (dropDownMenu == _sellMenu) {
        _sellMenu = nil;
    } else if (dropDownMenu == _pinpaiMenu) {
        _pinpaiMenu = nil;
    }
}

- (void)dropDownMenu:(QGDropDownMenu *)menu didSelectedRow:(NSInteger)row
{
    if (menu == _priceMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:100];
        if (row == 0) {
            btn.selected = NO;
        } else {
            btn.selected = YES;
        }
        [btn setTitle:_priceArray[row] forState:UIControlStateNormal];
        [btn setTitle:_priceArray[row] forState:UIControlStateSelected];
        YLButton *button = [self.secondNavigation viewWithTag:102];
        button.selected = NO;
        [button setTitle:_sellArray[0] forState:UIControlStateSelected];
        [button setTitle:_sellArray[0] forState:UIControlStateNormal];
        _order = @"price";//价格排序
        //为0时不排序，清空排序依据和排序方式
        if (row == 0) {
            _order = @"default";
            _action = @"";
        } else if (row == 1) {
            _action = @"asc";
        } else if (row == 2) {
            _action = @"desc";
        }
    } else if (menu == _sellMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:102];
        if (row == 0) {
            btn.selected = NO;
        } else {
            btn.selected = YES;
        }
        [btn setTitle:_sellArray[row] forState:UIControlStateNormal];
        [btn setTitle:_sellArray[row] forState:UIControlStateSelected];
        YLButton *button = [self.secondNavigation viewWithTag:100];
        button.selected = NO;
        [button setTitle:_priceArray[0] forState:UIControlStateSelected];
        [button setTitle:_priceArray[0] forState:UIControlStateNormal];
        _order = @"sales";//价格排序
        //为0时不排序，清空排序依据和排序方式
        if (row == 0) {
            _order = @"default";
            _action = @"";
        } else if (row == 1) {
            _action = @"asc";
        } else if (row == 2) {
            _action = @"desc";
        }
    } else if (menu == _pinpaiMenu) {
        YLButton *btn = [self.secondNavigation viewWithTag:101];
        [btn setTitle:_pinpaiArray[row][@"pinpainame"] forState:UIControlStateNormal];
        _pinpaiCode = _pinpaiArray[row][@"pinpaicode"];
    }
    //重新刷新 清空数据
    [self.dataArray removeAllObjects];
    [self.mTableView reloadData];
    [self startRequest];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    [cell setContentWithProductModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;//kScreenWidth*100.0/320.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductModel *model = self.dataArray[indexPath.row];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.productModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - UIScrollViewDelegate

#if 0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    WS(weakSelf);
    if (currentPostion - previousOffsetY > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        if (scrollView.contentSize.height <= kScreenHeight-44) {
            return;
        }
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, -20, kScreenWidth, kScreenHeight-44);
            weakSelf.secNavTopLayout.constant = -44;
            [weakSelf.view layoutIfNeeded];
        }];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if ((previousOffsetY - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
    {
        previousOffsetY = currentPostion;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.mTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64-44);
            weakSelf.secNavTopLayout.constant = 0;
            [weakSelf.view layoutIfNeeded];
        }];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
#endif

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
