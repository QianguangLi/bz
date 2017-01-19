//
//  GoodsPropertyCell.h
//  bz
//
//  Created by qianchuang on 2017/1/18.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountCollectionCellDelegate <NSObject>

- (void)numberOfBuyGoods:(NSUInteger)numberOfBuyGoods;

@end

@interface GoodsPropertyCell : UICollectionViewCell

@property (weak, nonatomic) id <CountCollectionCellDelegate> countDelegate;

@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *countTF;

@end
