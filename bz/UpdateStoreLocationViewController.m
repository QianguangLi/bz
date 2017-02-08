//
//  UpdateStoreLocationViewController.m
//  bz
//
//  Created by qianchuang on 2017/2/8.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "UpdateStoreLocationViewController.h"
#import "NetService.h"
#import "AddressPickerView.h"

#import "BMKMapView.h"
#import "UserLocationModel.h"
#import "BMKGeocodeSearch.h"
#import "BMKPointAnnotation.h"
#import "BMKPinAnnotationView.h"

@interface UpdateStoreLocationViewController () <BMKMapViewDelegate, AddressPickerViewDelegate, BMKGeoCodeSearchDelegate, UIAlertViewDelegate>
{
    UIButton *_updateButton;
    NSURLSessionTask *_getInfoTask;
    NSURLSessionTask *_task;
    BMKGeoCodeSearch *_search;//地理编码
    NSString *areaString;//地区名字字符串
    NSString *areaCodeString;//地区编码字符串
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *storeId;
@property (weak, nonatomic) IBOutlet AddressPickerView *conArea;//收货国家区域
@property (weak, nonatomic) IBOutlet UITextField *conRoad;//道路
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *longitude;//经度
@property (weak, nonatomic) IBOutlet UITextField *latitude;//纬度
@property (weak, nonatomic) IBOutlet UITextField *postRegion;//配送范围

@end

@implementation UpdateStoreLocationViewController
- (void)dealloc
{
    [_getInfoTask cancel];
    [_task cancel];
    NSLog(@"UpdateStoreLocationViewController dealloc");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
    }];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
        [_updateButton setTitle:Localized(@"修改") forState:UIControlStateNormal];
        _updateButton.backgroundColor = kPinkColor;
        [_updateButton addTarget:self action:@selector(updateStoreInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_updateButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.title = Localized(@"门店位置设置");
    
    [self getStoreInfo];
    
    //地图设置
    UserLocationModel *model = [Utility getUserLocationInformation];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    [self setMapCenterWith:center];
    
    _conArea.delegate = self;
}


- (void)setMapCenterWith:(CLLocationCoordinate2D)center
{
    BMKCoordinateRegion region;
    region.center = center;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [_mapView setRegion:region];
}

- (void)updateStoreInfo:(UIButton *)btn
{
    
}

- (void)getStoreInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 nil];
    WS(weakSelf);
    _getInfoTask = [NetService GET:@"api/Store/GetStoreInfo" parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            NSDictionary *dataDict = responseObject[kResponseData];
            [weakSelf reloadDataWithDict:dataDict];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_getInfoTask];
}

- (void)reloadDataWithDict:(NSDictionary *)dict
{
    _storeId.text = [dict objectForKey:@"storeId"];
    
    [_conArea setDefaultAddressWithAreaIDString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"addrcode"]]];
    areaString = [dict objectForKey:@"addr"];
    areaCodeString = [dict objectForKey:@"addrcode"];
    
    _conRoad.text = [dict objectForKey:@"road"];
    _detailAddress.text = [dict objectForKey:@"detailadress"];
    _latitude.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"latitude"]];
    _longitude.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"longitude"]];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(((NSString *)[dict objectForKey:@"latitude"]).doubleValue, ((NSString *)[dict objectForKey:@"longitude"]).doubleValue);
    [self setMapCenterWith:center];
}

- (IBAction)requestLocation:(UIButton *)sender
{
    if (IS_NULL_STRING(areaString)) {
        [Utility showString:Localized(@"请选择所在地区") onView:self.view];
        return;
    }
    if (IS_NULL_STRING(_conRoad.text)) {
        [Utility showString:Localized(@"请填写街道") onView:self.view];
        return;
    }
    [self geoCode];
}
//地理编码
- (void)geoCode
{
    if (!_search) {
        _search = [[BMKGeoCodeSearch alloc] init];
        _search.delegate = self;
    }
    BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc] init];
    option.city = areaString;
    option.address = _conRoad.text;
    BOOL flag = [_search geoCode:option];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrUpdateShoppingAddressSuccess object:nil];
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%f:%f  %@", result.location.latitude, result.location.longitude, result.address);
        // 添加一个PointAnnotation
        _latitude.text = [NSString stringWithFormat:@"%.6f", result.location.latitude];
        _longitude.text = [NSString stringWithFormat:@"%.6f", result.location.longitude];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = result.location.latitude;
        coor.longitude = result.location.longitude;
        annotation.coordinate = coor;
        annotation.title = result.address;
        //添加标注之前删除之前的标注
        [_mapView removeAnnotations:_mapView.annotations];
        [_mapView addAnnotation:annotation];
        _mapView.centerCoordinate = coor;
    }
    else {
        [Utility showString:Localized(@"抱歉，未找到结果") onView:self.view];
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}


#pragma mark - AddressPickerViewDelegate
- (void)addressSelectedCountry:(NSString *)countryid province:(NSString *)provinceid city:(NSString *)cityid county:(NSString *)countyid
{
    NSLog(@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid);
    areaCodeString = [NSString stringWithFormat:@"%@,%@,%@,%@", countryid, provinceid, cityid, countyid];
    _latitude.text = nil;
    _longitude.text = nil;
}

- (void)addressSelectedCountryName:(NSString *)countryName provinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName
{
    NSLog(@"%@,%@,%@,%@", countryName, provinceName, cityName, countyName);
    areaString = [NSString stringWithFormat:@"%@%@%@%@", countryName, provinceName, cityName, countyName];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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
