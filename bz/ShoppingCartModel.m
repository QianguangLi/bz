//
//  ShoppingCartModel.m
//  bz
//
//  Created by qianchuang on 2017/1/12.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    ShoppingCartModel *model = [[self class] allocWithZone:zone];
//    model.storename = self.storename;
//    model.totalMoney = self.totalMoney;
//    model.storelogo = self.storelogo;
//    model.products = self.products;
//    model.buyerIsChoosed = self.buyerIsChoosed;
//    model.buyerIsEditing = self.buyerIsEditing;
//    return model;
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    ShoppingCartModel *model = [[self class] allocWithZone:zone];
//    model.storename = self.storename;
//    model.totalMoney = self.totalMoney;
//    model.storelogo = self.storelogo;
//    model.products = self.products;
//    model.buyerIsChoosed = self.buyerIsChoosed;
//    model.buyerIsEditing = self.buyerIsEditing;
//    return model;
//}
@end
