//
//  GuideViewController.m
//  bz
//
//  Created by LQG on 2017/5/4.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)entryAction:(UIButton *)sender
{
    [UIView transitionWithView:appDelegate.window duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [appDelegate setRootController];
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        [UserDefaults setBool:YES forKey:kIsNotFirstOpenApp];
    }];
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
