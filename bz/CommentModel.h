//
//  CommentModel.h
//  bz
//
//  Created by qianchuang on 2017/1/17.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CommentModel;
@protocol CommentImageModel;

@interface CommentsModel : JSONModel

@property (assign, nonatomic) NSInteger allCount;//全部评论数量
@property (assign, nonatomic) NSInteger badCount;//差评数量
@property (assign, nonatomic) NSInteger goodCount;//好评数量
@property (assign, nonatomic) NSInteger imageCount;//有图品论数量
@property (assign, nonatomic) NSInteger mediumCount;//中评数量
@property (strong, nonatomic) NSArray<CommentModel> *comments;//评论数组

@end

/**
 评论model
 */
@interface CommentModel : JSONModel

@property (copy, nonatomic) NSString *id;//评论id
@property (copy, nonatomic) NSString *pname;//商品名称
@property (copy, nonatomic) NSString *member;//评论人
@property (assign, nonatomic) double price;//购买价格
@property (copy, nonatomic) NSString *type;//评论结果
@property (copy, nonatomic) NSString *content;//备注
@property (copy, nonatomic) NSString *faceUrl;//评论头像
@property (copy, nonatomic) NSString *commentDate;//评论时间

@property (strong, nonatomic) NSArray<CommentImageModel> *images;//评论图片
@end

/**
 评论图片model
 */
@interface CommentImageModel : JSONModel

@property (strong, nonatomic) NSURL *min;//小图
@property (strong, nonatomic) NSURL *src;//大图

@end


