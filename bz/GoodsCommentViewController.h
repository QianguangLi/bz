//
//  GoodsCommentViewController.h
//  bz
//
//  Created by qianchuang on 2017/1/20.
//  Copyright © 2017年 ing. All rights reserved.
//

#import "CollectionRefreshViewController.h"

typedef enum : NSUInteger {
    CommentFromGoods,//商品评论
    CommentFromTrade,//交易订单评价
} CommentFrom;

/**
 商品评论页面  交易订单评价
 */
@interface GoodsCommentViewController : CollectionRefreshViewController

@property (copy, nonatomic) NSString *productId;//商品id

@property (assign, nonatomic) CommentFrom commentFrom;//评价来自哪里

@end
