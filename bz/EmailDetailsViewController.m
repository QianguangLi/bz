//
//  EmailDetailsViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/13.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "EmailDetailsViewController.h"

@interface EmailDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailTitle;
@property (weak, nonatomic) IBOutlet UILabel *sendDate;
@property (weak, nonatomic) IBOutlet UILabel *emailContent;

@end

@implementation EmailDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _emailTitle.text = _model.title;
    _sendDate.text = _model.sendDate;
    _emailContent.text = _model.content;
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
