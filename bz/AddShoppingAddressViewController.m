//
//  AddShoppingAddressViewController.m
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "AddShoppingAddressViewController.h"
#import "BMKMapView.h"
#import "UserLocationModel.h"
#import "AddressPickerView.h"
#import "BMKGeocodeSearch.h"
#import "BMKPointAnnotation.h"
#import "BMKPinAnnotationView.h"
#import "NetService.h"
#import "ShoppingAddressModel.h"

@interface AddShoppingAddressViewController () <BMKMapViewDelegate, AddressPickerViewDelegate, BMKGeoCodeSearchDelegate, UIAlertViewDelegate, UITableViewDelegate>
{
    UIButton *_saveButton;
    NSString *areaString;//地区名字字符串
    NSString *areaCodeString;//地区编码字符串
    BMKGeoCodeSearch *_search;//地理编码
    NSURLSessionTask *_task;//添加或修改任务
    NSURLSessionTask *_getTask;//获取任务
    BOOL _isDefault;//是否是默认地址
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *conName;//收货人
@property (weak, nonatomic) IBOutlet AddressPickerView *conArea;//收货国家区域
@property (weak, nonatomic) IBOutlet UITextField *conRoad;//道路
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;//详细地址
@property (weak, nonatomic) IBOutlet UITextField *longitude;//经度
@property (weak, nonatomic) IBOutlet UITextField *latitude;//纬度
@property (weak, nonatomic) IBOutlet UITextField *postCode;//邮编
@property (weak, nonatomic) IBOutlet UITextField *conPhone;//电话号码
@property (weak, nonatomic) IBOutlet UITextField *conMobile;//手机号码

@end

@implementation AddShoppingAddressViewController

- (void)dealloc
{
    [_getTask cancel];
    [_task cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"收货地址");
    self.view.backgroundColor = QGCOLOR(237, 238, 239, 1);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    
    [self loadAddress];
    
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

- (void)loadAddress
{
    if (_isEdit) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     kLoginToken, @"Token",
                                     _conId, @"conaddid",
                                     nil];
        __weak AddShoppingAddressViewController *weakSelf = self;
        _getTask = [NetService GET:kGetAddressByIdUrl parameters:dict complete:^(id responseObject, NSError *error) {
            [Utility hideHUDForView:weakSelf.view];
            if (error) {
                NSLog(@"failure:%@", error);
                [Utility showString:error.localizedDescription onView:weakSelf.view];
                return ;
            }
            NSLog(@"%@", responseObject);
            if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
                NSDictionary *dataDict = responseObject[kResponseData];
                ShoppingAddressModel *model = [[ShoppingAddressModel alloc] initWithDictionary:dataDict error:nil];
                [self reloadDataWithShoppingAddressModel:model andWeakSelf:weakSelf];
            } else {
                [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
            }
        }];
        [Utility showHUDAddedTo:self.view forTask:_getTask];
    }
}

- (void)reloadDataWithShoppingAddressModel:(ShoppingAddressModel *)model andWeakSelf:(AddShoppingAddressViewController * __weak)weakSelf
{
    _conName.text = model.conName;
    
    [_conArea setDefaultAddressWithAreaIDString:model.conAreacode];
    areaString = model.conArea;
    areaCodeString = model.conAreacode;
    
    _conRoad.text = model.conAddr;
    _detailAddress.text = model.condetail;
    _latitude.text = model.latitude;
    _longitude.text = model.longitude;
    _postCode.text = model.conZipCode;
    _conPhone.text = model.conPhone;
    _conMobile.text = model.conMobile;
    
    _isDefault = model.isDefault;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
    [self setMapCenterWith:center];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
    }];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 49);
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth, 49);
        NSString *title = _isEdit ? Localized(@"修改") : Localized(@"保存");
        [_saveButton setTitle:title forState:UIControlStateNormal];
        _saveButton.backgroundColor = kPinkColor;
        [_saveButton addTarget:self action:@selector(saveShoppingAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.superview addSubview:_saveButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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


- (void)saveShoppingAddress:(UIButton *)btn
{
    if (IS_NULL_STRING(_conName.text)) {
        [Utility showString:Localized(@"请填写收货人姓名") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(areaString)) {
        [Utility showString:Localized(@"请选择收货地址") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_conRoad.text)) {
        [Utility showString:Localized(@"请填写街道信息") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_detailAddress.text)) {
        [Utility showString:Localized(@"请填写楼号/门牌号") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_conRoad.text)) {
        [Utility showString:Localized(@"请填写街道信息") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_longitude.text) || IS_NULL_STRING(_latitude.text)) {
        [Utility showString:Localized(@"请点击查询查询位置经纬度") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_postCode.text)) {
        [Utility showString:Localized(@"请填写邮政编码") onView:appDelegate.window];
        return;
    }
    if (IS_NULL_STRING(_conPhone.text)) {
        _conPhone.text = @"";
    }
    if (IS_NULL_STRING(_conMobile.text)) {
        [Utility showString:Localized(@"请填写手机号码") onView:appDelegate.window];
        return;
    }
    if (![Utility isLegalMobile:_conMobile.text]) {
        [Utility showString:Localized(@"请正确输入手机号") onView:appDelegate.window];
        return;
    }
    
    NSString *action = _isEdit ? _conId : @"add";
    NSString *isDefault = _isDefault ? @"1" : @"0";
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 kLoginToken, @"Token",
                                 _conName.text, @"conaddressname",
                                 _conMobile.text, @"conaddressmobile",
                                 _conPhone.text, @"conaddressphone",
                                 areaCodeString, @"conaddressaddress",
                                 _conRoad.text, @"conaddressroad",
                                 _detailAddress.text, @"detailaddress",
                                 _latitude.text, @"latitude",
                                 _longitude.text, @"longitude",
                                 isDefault, @"isdefaultaddress",//是否是默认地址
                                 action, @"action",//添加使用add 修改使用地址id
                                 _postCode.text, @"postcode",
                                 nil];
    __weak AddShoppingAddressViewController *weakSelf = self;
    _task = [NetService POST:kAddOrUpdateShoppingAddressUrl parameters:dict complete:^(id responseObject, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error) {
            NSLog(@"failure:%@", error);
            [Utility showString:error.localizedDescription onView:weakSelf.view];
            return ;
        }
        NSLog(@"%@", responseObject);
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:Localized(@"提示") message:Localized(@"更新收货地址成功") delegate:self cancelButtonTitle:Localized(@"确定") otherButtonTitles:nil, nil];
            [av show];
        } else {
            [Utility showString:responseObject[kErrMsg] onView:weakSelf.view];
        }
    }];
    [Utility showHUDAddedTo:self.view forTask:_task];
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
