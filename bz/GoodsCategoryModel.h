//
//  GoodsCategoryModel.h
//  bz
//
//  Created by qianchuang on 2017/1/11.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GoodsCategoryModel;

@interface GoodsCategoryModel : JSONModel

@property (copy, nonatomic) NSString *categoryId;//类别id
@property (copy, nonatomic) NSString *categoryName;//类别名
@property (copy, nonatomic) NSString *categoryPID;//类别父id
@property (assign, nonatomic) BOOL hasChild;//是否有子类
@property (strong, nonatomic) NSArray<GoodsCategoryModel> *subCategories;//子类别

@end
