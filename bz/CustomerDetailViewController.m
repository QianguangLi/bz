//
//  CustomerDetailViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/28.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CustomerModel.h"

@interface CustomerDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *customerFace;
@property (weak, nonatomic) IBOutlet UILabel *memberId;//商户编号
@property (weak, nonatomic) IBOutlet UILabel *customerName;//客户姓名
@property (weak, nonatomic) IBOutlet UILabel *age;//年龄
@property (weak, nonatomic) IBOutlet UILabel *sex;//性别
@property (weak, nonatomic) IBOutlet UILabel *birthday;//生日
@property (weak, nonatomic) IBOutlet UILabel *sfz;//身份证
@property (weak, nonatomic) IBOutlet UILabel *phone;//联系电话
@property (weak, nonatomic) IBOutlet UILabel *mobile;//移动电话
@property (weak, nonatomic) IBOutlet UILabel *qq;//QQ
@property (weak, nonatomic) IBOutlet UILabel *wx;//微信
@property (weak, nonatomic) IBOutlet UILabel *wb;//微博
@property (weak, nonatomic) IBOutlet UILabel *email;//email
@property (weak, nonatomic) IBOutlet UILabel *address;//城市
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UILabel *postolCode;//邮编
@property (weak, nonatomic) IBOutlet UILabel *comment;//其他信息

@end

@implementation CustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"客户详细信息");
    
    [self reloadData];
}

- (void)reloadData
{
    [_customerFace setImageWithURL:[NSURL URLWithString:_customerModel.photo] placeholderImage:[UIImage imageNamed:@"member-head"]];
    _memberId.text = _customerModel.memberid;
    _customerName.text = _customerModel.cname;
    _age.text = _customerModel.age;
    
    _sex.text = _customerModel.sex.integerValue == 0 ? @"女" : @"男";
    
    _birthday.text = _customerModel.birthday;
    
    _sfz.text = _customerModel.sfz;
    _phone.text = _customerModel.phone;
    _mobile.text = _customerModel.mobileTele;
    _qq.text = _customerModel.qq;
    _wx.text = _customerModel.wx;
    _wb.text = _customerModel.wb;
    _email.text = _customerModel.email;
    
    _address.text = _customerModel.yaddress;
    _detailAddress.text = _customerModel.address;
    _postolCode.text = _customerModel.postolCode;
    _comment.text = _customerModel.remark;
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
