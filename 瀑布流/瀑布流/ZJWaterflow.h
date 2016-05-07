//
//  ZJWaterflow.h
//  瀑布流
//
//  Created by 张杰 on 16/5/7.
//  Copyright © 2016年 zhangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJWaterflow;

@protocol ZJWaterflowDelegate <NSObject>

@required
- (CGFloat) waterflow:(ZJWaterflow *)waterflow heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCountForwaterflow:(ZJWaterflow *)waterflow;
- (CGFloat)columnMarginForwaterflow:(ZJWaterflow *)waterflow;
- (CGFloat)rowMarginForwaterflow:(ZJWaterflow *)waterflow;
- (UIEdgeInsets)edgeInsetsForwaterflow:(ZJWaterflow *)waterflow;

@end

@interface ZJWaterflow : UICollectionViewLayout

@property (nonatomic, weak) id<ZJWaterflowDelegate>delegate;

@end
