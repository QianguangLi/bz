//
//  TradeCommentViewController.m
//  bz
//
//  Created by qianchuang on 2017/3/14.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "TradeCommentViewController.h"
#import "StarLevelCell.h"
#import "CumulativeCommentCell.h"
#import "CommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetService.h"
#import "CommentModel.h"
#import "GoodsCommentViewController.h"

@interface TradeCommentViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSURLSessionTask *_task;
}

@property (strong, nonatomic) NSDictionary *bad;
@property (strong, nonatomic) NSDictionary *good;
@property (strong, nonatomic) NSDictionary *medium;
@property (strong, nonatomic) NSDictionary *total;

@property (strong, nonatomic) NSDictionary *starLevel;

@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation TradeCommentViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"TradeCommentViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"交易评价");
    
    _comments = [NSMutableArray array];
    
    self.mTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.mTableView.contentInset = UIEdgeInsetsZero;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self registerCellForCellReuseIdentifier:@"StarLevelCell"];
    [self registerCellForCellReuseIdentifier:@"CumulativeCommentCell"];
    [self registerCellForCellReuseIdentifier:@"CommentCell"];
    
    [self getOrderInfo];
}

- (void)getOrderInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 StringFromNumber(self.pageIndex), kPageIndex,
                                 StringFromNumber(5), kPageSize,
                                 @"all", @"action",
                                 nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Store/TransactionEvaluation" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            NSArray *commentsArr = dataDict[@"commentGroup"][@"comments"];
            for (NSDictionary *d in commentsArr) {
                CommentModel *model = [[CommentModel alloc] initWithDictionary:d error:nil];
                [weakSelf.comments addObject:model];
            }
            weakSelf.bad = dataDict[@"cumulativeEvaluation"][@"bad"];
            weakSelf.good = dataDict[@"cumulativeEvaluation"][@"good"];
            weakSelf.medium = dataDict[@"cumulativeEvaluation"][@"medium"];
            weakSelf.total = dataDict[@"cumulativeEvaluation"][@"total"];
            
            weakSelf.starLevel = dataDict[@"starLevel"];
            
            [weakSelf.mTableView reloadData];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.comments.count;
}

- (NSArray *)convertDict:(NSDictionary *)dict ToArray:(NSString *)firstStr
{
    NSMutableArray *arr = [NSMutableArray arrayWithObject:firstStr];
    [arr addObject:[NSString stringWithFormat:@"%@", dict[@"lastWeek"]]];
    [arr addObject:[NSString stringWithFormat:@"%@", dict[@"lastJanuary"]]];
    [arr addObject:[NSString stringWithFormat:@"%@", dict[@"lastJune"]]];
    [arr addObject:[NSString stringWithFormat:@"%@", dict[@"JuneAgo"]]];
    [arr addObject:[NSString stringWithFormat:@"%@", dict[@"sum"]]];
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CumulativeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CumulativeCommentCell" forIndexPath:indexPath];
        if (_good && _bad && _medium && _total) {
            [cell.matrix addRecord:[self convertDict:_good ToArray:@"好评"]];
            [cell.matrix addRecord:[self convertDict:_medium ToArray:@"中评"]];
            [cell.matrix addRecord:[self convertDict:_bad ToArray:@"差评"]];
            [cell.matrix addRecord:[self convertDict:_total ToArray:@"总计"]];
        }
        //赋值后清空数据，防止滑动时重复添加数据
        _good = nil;
        _bad = nil;
        _medium = nil;
        _total = nil;
        return cell;
    } else if (indexPath.section == 1) {
        StarLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StarLevelCell" forIndexPath:indexPath];
        cell.startView1.progress = [[_starLevel objectForKey:@"commodityAndDescriptionMatchLevel"] floatValue];
        cell.startView1.enabled = NO;
        cell.startView2.progress = [[_starLevel objectForKey:@"sellerServiceAttitudeLevel"] floatValue];
        cell.startView2.enabled = NO;
        cell.startView3.progress = [[_starLevel objectForKey:@"sellerDeliverySpeedLevel"] floatValue];
        cell.startView3.enabled = NO;
        cell.startView4.progress = [[_starLevel objectForKey:@"ogisticsDeliverySpeedLevel"] floatValue];
        cell.startView4.enabled = NO;
        cell.startView5.progress = [[_starLevel objectForKey:@"deliverymanAttitudeLevel"] floatValue];
        cell.startView5.enabled = NO;
        return cell;
    } else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        [cell setContentWithCommentModel:self.comments[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 205;
    } else if (indexPath.section == 1) {
        return 165;
    }
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"CommentCell" cacheByIndexPath:indexPath configuration:^(CommentCell *cell) {
        [cell setContentWithCommentModel:weakSelf.comments[indexPath.row]];
    }];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        GoodsCommentViewController *vc = [[GoodsCommentViewController alloc] init];
        vc.commentFrom = CommentFromTrade;
        [self.navigationController pushViewController:vc animated:YES];
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
