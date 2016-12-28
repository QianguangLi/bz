//
//  DataBaseService.m
//  bz
//
//  Created by qianchuang on 2016/12/28.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "DataBaseService.h"
#import "FMDB.h"
#import "AFHTTPSessionManager.h"
#import "NetService.h"
#import "Address.h"

@interface DataBaseService ()

@property (strong, nonatomic) FMDatabase *db;

@end

static DataBaseService *sharedService = nil;

@implementation DataBaseService

+ (instancetype)sharedService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

- (BOOL)openDataBase
{
    //数据的路径，放在沙盒的cache下面
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:@"address.sqlite"];
    
    //创建并且打开一个数据库
    _db = [FMDatabase databaseWithPath:filePath];
    
    BOOL flag = [_db open];
    if (!flag) {
        NSLog(@"打开数据库失败");
    }
    return flag;
}

- (BOOL)createAddressTable
{
    BOOL created = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS `address` (`id` int(11) NOT NULL, `areaId` varchar(10) NOT NULL, `areaName` varchar(20) NOT NULL, `level` smallint(6) NOT NULL, `areaPid` varchar(10) DEFAULT NULL, PRIMARY KEY (`id`))"];
    if (![_db executeUpdate:@"delete from address"])
    {
        NSLog(@"清理address表失败!");
        return NO;
    }
    return created;
}

- (BOOL)closeDataBase
{
    return [_db close];
}

- (void)requestAddress
{
    BOOL opend = [self openDataBase];
    if (!opend) {
        NSLog(@"打开数据库失败");
        return;
    }
    BOOL createTable = [self createAddressTable];
    if (!createTable) {
        NSLog(@"创建address表失败");
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://103.48.169.52/BzApi/api/User/GetCityDatabase" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[kStatusCode] integerValue] == NetStatusSuccess) {
            //开启事物
            BOOL oldshouldcachestatements = _db.shouldCacheStatements;
            [_db setShouldCacheStatements:YES];
            [_db beginTransaction];
            BOOL result = NO;
            
            NSArray *countryArray = responseObject[kResponseData];
            for (NSDictionary *countryDict in countryArray) {
                Address *country = [[Address alloc] initWithDict:countryDict];
                [self insertAddress:country];
                NSArray *proviceArray = countryDict[@"subordinates"];
                for (NSDictionary *provinceDict in proviceArray) {
                    Address *provice = [[Address alloc] initWithDict:provinceDict];
                    [self insertAddress:provice];
                    NSArray *cityArray = provinceDict[@"subordinates"];
                    for (NSDictionary *cityDict in cityArray) {
                        Address *city = [[Address alloc] initWithDict:cityDict];
                        [self insertAddress:city];
                        NSArray *countyArray = cityDict[@"subordinates"];
                        for (NSDictionary *countyDict in countyArray) {
                            Address *county = [[Address alloc] initWithDict:countyDict];
                            [self insertAddress:county];
                        }
                    }
                }
            }
            //提交事务
            result = [_db commit];
            [_db setShouldCacheStatements:oldshouldcachestatements];
            if (!result) {
                NSLog(@"储存出错");
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"address_cached"];
            } else {
                NSLog(@"储存成功");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"address_cached"];
            }
//            [self closeDataBase];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self closeDataBase];
    }];
}

- (BOOL)insertAddress:(Address *)address
{
    BOOL insert = [_db executeUpdate:@"insert into address (id,areaId,areaName,level,areaPid) values(?,?,?,?,?)",[NSNumber numberWithInt:address.ID], address.areaId, address.areaName, [NSNumber numberWithInt:address.level], address.areaPid];

    return insert;
}

- (void)selectAll {
    if (![self openDataBase]) {
        return;
    }
    FMResultSet *set = [_db executeQuery:@"select * from address"];
    NSLog(@"id areaId areaName level areaPid");
    while ([set next]) {
        NSInteger ID =[set intForColumn:@"ID"];
        NSString *areaId =  [set stringForColumn:@"areaId"];
        NSString *areaName = [set stringForColumn:@"areaName"];
        NSInteger level =[set intForColumn:@"level"];
        NSString *areaPid = [set stringForColumn:@"areaPid"];
        NSLog(@"=:%ld, %@, %@, %ld, %@",(long)ID, areaId, areaName, (long)level, areaPid);
    }
    [self closeDataBase];
}

- (NSArray<Address *> *)getAddressWithAreaPid:(NSString *)areaPid
{
    if (![self openDataBase]) {
        return nil;
    }
    //410200 开封
    FMResultSet *set = [_db executeQuery:@"select * from address where areapid = ?", areaPid];
    NSMutableArray *addressArray = [NSMutableArray array];
    while ([set next]) {
        Address *address = [[Address alloc] init];
        address.ID =[set intForColumn:@"ID"];
        address.areaId =  [set stringForColumn:@"areaId"];
        address.areaName = [set stringForColumn:@"areaName"];
        address.level =[set intForColumn:@"level"];
        address.areaPid = [set stringForColumn:@"areaPid"];
        [addressArray addObject:address];
    }
    [self closeDataBase];
    return addressArray;
}
@end
