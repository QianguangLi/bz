//
//  ProductModel.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol PropertysModel;
@protocol ProductDetailModel;
/**
 商品模型
 */
@interface ProductModel : JSONModel

@property (copy, nonatomic) NSString *productId;//商品id
@property (copy, nonatomic) NSString *pName;//商品名字
@property (assign, nonatomic) double price;//价格
@property (assign, nonatomic) double markprice;//市场价格
@property (copy, nonatomic) NSString *pImgUrl;//图片
@property (assign, nonatomic) double pv;//积分
@property (assign, nonatomic) NSUInteger quantity;//数量 在常购清单里代表购买次数
@property (copy, nonatomic) NSString<Optional> *propertyd;//尺寸
@property (copy, nonatomic) NSString<Optional> *pdetailId;//商品详细id 
@property (copy, nonatomic) NSString<Optional> *favTime;//收藏时间
@property (copy, nonatomic) NSString *shipping;//配送方式 “次日达”
@property (copy, nonatomic) NSString *kw;//关键字
@property (copy, nonatomic) NSString *storelogo;//卖家头像
@property (copy, nonatomic) NSString *storename;//卖家名字

@property (strong, nonatomic) NSArray<PropertysModel> *propertylist;//属性列表

@property (strong, nonatomic) NSArray<ProductDetailModel> *pdetaillist;//子商品详细

// 商品左侧按钮是否选中
@property (nonatomic,assign) BOOL productIsChoosed;
@end


@protocol PropertyModel;
/**
 属性列表
 */
@interface PropertysModel : JSONModel

@property (nonatomic,copy) NSString *propertyname;//属性名
@property (strong, nonatomic) NSArray<PropertyModel> *propertyid;//

@end

/**
 属性model
 */
@interface PropertyModel : JSONModel

@property (nonatomic,copy) NSString *propertyId;//属性id
@property (nonatomic,copy) NSString *propertyName;//属性名

@end

/**
 子商品内容
 */
@interface ProductDetailModel : JSONModel
@property (nonatomic,copy) NSString *pdetailId;//子商品id
@property (nonatomic,copy) NSString *pdetailcode;//子商品编码
@property (nonatomic,copy) NSString *pdetailimg;//图片
@property (nonatomic,copy) NSString *pdetailname;//子商品属性描述
@property (nonatomic,assign) double price;//价格
@property (nonatomic,copy) NSString *propertyid;//子商品属性值
@property (nonatomic,copy) NSString *propertyname;//子商品属性描述
@end

