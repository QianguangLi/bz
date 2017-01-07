//
//  MenDianFuncViewController.m
//  bz
//
//  Created by LQG on 2017/1/7.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "MenDianFuncViewController.h"
#import "MeCell.h"

@interface MenDianFuncViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *functionTableView;
@property (strong, nonatomic) NSArray *functionArray;

@end

@implementation MenDianFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initFunctionArray];
    _functionTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [_functionTableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
}

- (void)initFunctionArray
{
    switch (_menu) {
        case 0:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"抢单/附近订单"), Localized(@"订单发货"), Localized(@"送达订单"), Localized(@"交易订单"), Localized(@"交易评价"), Localized(@"审核退货单"), nil];
        }
            break;
        case 1:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"送达时间折扣"), Localized(@"我的门店"), Localized(@"门店装修"), Localized(@"域名设置"), Localized(@"门店信息修改"), Localized(@"门店位置设置"), nil];
        }
            break;
        case 2:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"商品上下架"), Localized(@"库存查询"), Localized(@"仓库管理"), Localized(@"申请入库"), Localized(@"入库查询"), nil];
        }
            break;
        case 3:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"商品发布"), Localized(@"商品查询"), Localized(@"在线订货"), Localized(@"在线订货订单"), nil];
        }
            break;
        case 4:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"门店级别设置"), Localized(@"添加客户"), Localized(@"查询客户"), nil];
        }
            break;
        case 5:
        {
            _functionArray = [NSArray arrayWithObjects:Localized(@"写信件"), Localized(@"收件箱"), Localized(@"发件箱"), Localized(@"废件箱"), nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell" forIndexPath:indexPath];
    [cell setContentWithText:_functionArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
