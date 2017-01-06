//
//  BonusScanDetailsViewController.m
//  bz
//
//  Created by LQG on 2017/1/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "BonusScanDetailsViewController.h"

@interface BonusScanDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *status;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *sxf;
@property (weak, nonatomic) IBOutlet UILabel *bankname;
@property (weak, nonatomic) IBOutlet UILabel *accountname;
@property (weak, nonatomic) IBOutlet UILabel *bankaccount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *note;

@end

@implementation BonusScanDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"奖金提现");
    [self reloadData];
}

- (void)reloadData
{
    [_status setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", _model.isAuditing]] forState:UIControlStateNormal];
    if ([_model.isAuditing isEqualToString:@"0"]) {
        [_status setTitle:Localized(@"未处理") forState:UIControlStateNormal];
    } else if ([_model.isAuditing isEqualToString:@"1"]) {
        [_status setTitle:Localized(@"处理中") forState:UIControlStateNormal];
    } else if ([_model.isAuditing isEqualToString:@"2"]) {
        [_status setTitle:Localized(@"已汇款") forState:UIControlStateNormal];
    } else if ([_model.isAuditing isEqualToString:@"3"]) {
        [_status setTitle:Localized(@"卡号有误") forState:UIControlStateNormal];
    } else if ([_model.isAuditing isEqualToString:@"4"]) {
        [_status setTitle:Localized(@"待审核") forState:UIControlStateNormal];
    }
    _money.text = [NSString stringWithFormat:@"%.2f", _model.withdrawMoney];
    _sxf.text = [NSString stringWithFormat:@"%.2f", _model.sxf];
    _bankname.text = _model.bankname;
    _accountname.text = _model.kaihuName;
    _bankaccount.text = _model.bankcard;
    _time.text = _model.withdrawTime;
    _note.text = _model.note;
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
