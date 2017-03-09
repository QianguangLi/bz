//
//  OrderOnlineViewController.m
//  bz
//
//  Created by qianchuang on 2017/3/6.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "OrderOnlineViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectDelegate <JSExport>

- (void)callCamera;
- (void)share:(NSString *)shareString;

@end

@interface OrderOnlineViewController () <UIWebViewDelegate, JSObjectDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (strong, nonatomic) JSContext *jsContext;
@end

@implementation OrderOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    _mWebView.delegate = self;
    [_mWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"Toyun"] = self;
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - JSObjcDelegate

- (void)callCamera {
    NSLog(@"callCamera");
    JSValue *picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:@[@"photos"]];
}

- (void)share:(NSString *)shareString {
    NSLog(@"share:%@", shareString);
    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
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
