//
//  DZMoneyDetailsViewController.m
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "DZMoneyDetailsViewController.h"

@interface DZMoneyDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *direction;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *kmType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *note;

@end

@implementation DZMoneyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"账户明细");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self reloadData];
}

- (void)reloadData
{
    if ([_model.direction isEqualToString:@"0"]) {
        _direction.text = Localized(@"转入金额");
        _money.text = [NSString stringWithFormat:@"+%.2f", _model.money];
    } else {
        _direction.text = Localized(@"转出金额");
        _money.text = [NSString stringWithFormat:@"-%.2f", _model.money];
    }
    _balance.text = [NSString stringWithFormat:@"%.2f", _balanceMoney];
    _kmType.text = _model.kmType;
    _time.text = _model.time;
    _note.text = [NSString stringWithFormat:@"摘要:%@", _model.note];
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
