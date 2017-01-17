//
//  AppDelegate.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "AppDelegate.h"
#import "BMKMapManager.h"
#import "LocationService.h"
#import "LoginViewController.h"
#import "UIKit+AFNetworking.h"

#import "IQKeyboardManager.h"

#import "BaseNavigationController.h"
#import "FirstPageViewController.h"
#import "GoodsCategoryViewController.h"
#import "ShoppingCartViewController.h"
#import "MeViewController.h"

#import "DataBaseService.h"

#import "UIView+Addition.h"

@interface AppDelegate () <UITabBarControllerDelegate, UIAlertViewDelegate>
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // Override point for customization after application launch.
    //注册重新登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogon:) name:kReLoginNotification object:nil];
    [self systemSetting];
    //百度地图
    [self setBMKMap];
    //初始化控制器
    [self setRootController];
    
    //处理地址 数据库
    BOOL addressCached = [[NSUserDefaults standardUserDefaults] boolForKey:@"address_cached"];
    DataBaseService *service = [DataBaseService sharedService];
    
    if (!addressCached) {
        [service requestAddress];
    } else {
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setRootController
{
    //首页
    FirstPageViewController *firstPage = [[FirstPageViewController alloc] init];
    UITabBarItem *firstPageItem = [[UITabBarItem alloc] initWithTitle:Localized(@"首页") image:[[UIImage imageNamed:@"buttom_home-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"buttom_home-red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    firstPage.title = Localized(@"博真科际");
    [firstPage setTabBarItem:firstPageItem];
    BaseNavigationController *firstPageNvc = [[BaseNavigationController alloc] initWithRootViewController:firstPage];
    //分类
    GoodsCategoryViewController *goodsCategory = [[GoodsCategoryViewController alloc] init];
    UITabBarItem *goodsCategoryItem = [[UITabBarItem alloc] initWithTitle:Localized(@"商品分类") image:[[UIImage imageNamed:@"buttom_fenlei-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"buttom_fenlei-red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    goodsCategory.title = Localized(@"商品分类");
    [goodsCategory setTabBarItem:goodsCategoryItem];
    BaseNavigationController *goodsCategoryNvc = [[BaseNavigationController alloc] initWithRootViewController:goodsCategory];

    //购物车
    ShoppingCartViewController *shoppingCart = [[ShoppingCartViewController alloc] init];
    shoppingCart.isRequireRefreshFooter = YES;
    shoppingCart.isRequireRefreshHeader = YES;
    UITabBarItem *shoppingCartItem = [[UITabBarItem alloc] initWithTitle:Localized(@"购物车") image:[[UIImage imageNamed:@"buttom-shopping-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"buttom-shopping-red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    shoppingCartItem.badgeValue = @"99+";
    shoppingCart.title = Localized(@"购物车");
    [shoppingCart setTabBarItem:shoppingCartItem];
    BaseNavigationController *shoppingCartNvc = [[BaseNavigationController alloc] initWithRootViewController:shoppingCart];
    //我
    MeViewController *me = [[MeViewController alloc] init];
    UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:Localized(@"我") image:[[UIImage imageNamed:@"buttom-Persona-gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"buttom-Persona-red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    me.title = Localized(@"我");
    [me setTabBarItem:meItem];
    BaseNavigationController *meNvc = [[BaseNavigationController alloc] initWithRootViewController:me];
    //Tabbar
    _rootController = [[BaseTabBarController alloc] init];
    _rootController.delegate = self;
    _rootController.viewControllers = @[firstPageNvc, goodsCategoryNvc, shoppingCartNvc, meNvc];
    self.window.rootViewController = nil;
    self.window.rootViewController = _rootController;
}
//退出
- (void)logout
{
    //清空登录信息
    kLoginUserName = nil;
    kLoginToken = nil;
    kIsLogin = NO;
    //重新加载所有页面
    [self setRootController];
}

//重新登录
- (void)reLogon:(NSNotification *)notify
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"请重新登录") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
    av.tag = 1001;
    [av show];
}


/**
 系统设置
 */
- (void)systemSetting
{
    //设置不透明
//    [UINavigationBar appearance].translucent = NO;
    [UITabBar appearance].translucent = NO;
    //导航栏颜色
//    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].translucent = YES;
    [UINavigationBar appearance].tintColor = [UIColor darkGrayColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:20]};
    //tabbar 字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kPinkColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //键盘设置
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.keyboardDistanceFromTextField = 5.f;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    //网络状态
    kHasNet = YES;//默认有网络，防止网络延迟导致没有网络
    AFNetworkReachabilityManager *nrm = [AFNetworkReachabilityManager sharedManager];
    [nrm startMonitoring];
    __block AFNetworkReachabilityManager *weaknrm = nrm;
    [nrm setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld:%@", (long)status, [weaknrm localizedNetworkReachabilityStatusString]);
        kHasNet = status != AFNetworkReachabilityStatusNotReachable ? YES : NO;
    }];
    //网络指示器
    AFNetworkActivityIndicatorManager *manager = [AFNetworkActivityIndicatorManager sharedManager];
    manager.enabled = YES;
}

#pragma mark 百度地图
- (void)setBMKMap
{
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:kBaiduMapKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"baidu map manager start failed!");
    } else {
        NSLog(@"baidu map manager start success!");
    }
    
    //开启定位
    //TODO:开发阶段暂时关闭定位
//    LocationService *service = [LocationService sharedLocationService];
//    [service startUserLocationService];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        [self logout];
    }
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //没登陆不允许进入购物车页面，自动跳转到登陆页面
    if (!kIsLogin) {
        if ([tabBarController.viewControllers indexOfObject:viewController] == 2) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *loginNvc = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [_rootController presentViewController:loginNvc animated:YES completion:^{
                // code
            }];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"bz"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
