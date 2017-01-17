//
//  GoodsDetailViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "NetService.h"

@interface GoodsDetailViewController ()
{
    NSURLSessionTask *_task;
}
@end

@implementation GoodsDetailViewController

- (void)dealloc
{
    [_task cancel];
    NSLog(@"GoodsDetailViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localized(@"商品详情");
    [self getProductDetais];
}

- (void)getProductDetais
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_productId, @"productId", nil];
    WS(weakSelf);
    _task = [NetService POST:@"api/Home/ProductDetails" parameters:dict complete:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"failure:%ld:%@", (long)error.code, error.localizedDescription);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
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
