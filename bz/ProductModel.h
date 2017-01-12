//
//  ProductModel.h
//  bz
//
//  Created by qianchuang on 2016/12/29.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ModelDeatail;
/**
 商品模型
 */
@interface ProductModel : JSONModel

@property (copy, nonatomic) NSString *productId;//商品id
@property (copy, nonatomic) NSString *pName;//商品名字
@property (assign, nonatomic) double price;//价格
@property (copy, nonatomic) NSString *pImgUrl;//图片
@property (assign, nonatomic) double pv;//积分
@property (assign, nonatomic) NSUInteger quantity;//数量 在常购清单里代表购买次数
@property (copy, nonatomic) NSString<Optional> *propertyd;//尺寸
@property (copy, nonatomic) NSString<Optional> *pdetailId;//商品详细id 
@property (copy, nonatomic) NSString<Optional> *favTime;//收藏时间

@property (strong, nonatomic) NSArray<ModelDeatail> *model_detail;
// 商品左侧按钮是否选中
@property (nonatomic,assign) BOOL productIsChoosed;
@end

@interface ModelDeatail : JSONModel

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *type_name;
@property (nonatomic,copy) NSString *value;

@end
