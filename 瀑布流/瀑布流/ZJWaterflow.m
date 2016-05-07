//
//  ZJWaterflow.m
//  瀑布流
//
//  Created by 张杰 on 16/5/7.
//  Copyright © 2016年 zhangjie. All rights reserved.
//

#import "ZJWaterflow.h"

//默认的列数
static const NSInteger ZJDefaultColumnCount = 3;
//每一列的间距
static const CGFloat ZJDefaultColumnMargin = 10;
//每一行的间距
static const CGFloat ZJDefaultRowMargin = 10;
//边缘的间距
static const UIEdgeInsets ZJDefaultEdgeInsets = {10,10,10,10};

@interface ZJWaterflow()
//存放所有的cell的布局属性
@property (strong, nonatomic) NSMutableArray *attrsArray;
//存放所有列当前的高度
@property (strong, nonatomic) NSMutableArray *ColumnHeights;

@end

@implementation ZJWaterflow

//懒加载

-(NSMutableArray *) ColumnHeights
{
    if (!_ColumnHeights) {
        _ColumnHeights = [NSMutableArray array];
    }
    return _ColumnHeights;
}

- (NSMutableArray *) attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

//初始化
- (void)prepareLayout
{
    [super prepareLayout];
    //清除数组里的所有高度
    [self.ColumnHeights removeAllObjects];
    for (NSInteger i = 0; i < ZJDefaultColumnCount; i++) {
        self.ColumnHeights[i] = @(ZJDefaultEdgeInsets.top);
    }
    
    //清除数组的所有属性
    [self.attrsArray removeAllObjects];
    
    //找到所有cell的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
}


//决定cell的排布
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

//返回布局的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //得到collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //得到每个单元的宽度
    CGFloat w = (collectionViewW - ZJDefaultEdgeInsets.left - ZJDefaultEdgeInsets.right - (ZJDefaultColumnCount-1)*ZJDefaultColumnMargin)/ZJDefaultColumnCount;

    //找到哪一列的高度最短
    NSInteger destColumn = 0 ;
    CGFloat minColumnHeight = [self.ColumnHeights[0] doubleValue];
    for (NSInteger i = 1; i < ZJDefaultColumnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.ColumnHeights[i] doubleValue];
        //一旦发现有一列高度比最小的高度还小，则把这个高度纪录在minColumnHeight上，然后纪录下最短高度的i
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat h = 50 + arc4random_uniform(100);
    CGFloat x = ZJDefaultEdgeInsets.left + (w + ZJDefaultColumnMargin) * destColumn;
    CGFloat y = minColumnHeight;
    
    if(y != ZJDefaultEdgeInsets.top)
    {
        y += ZJDefaultRowMargin;
    }
    //设置布局的属性
    attrs.frame = CGRectMake(x, y, w, h);
    
    //更新最短哪一列的高度
    self.ColumnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

-(CGSize)collectionViewContentSize
{
    //找到哪一列的高度最长
    CGFloat maxColumnHeight = [self.ColumnHeights[0] doubleValue];
    for (NSInteger i = 1; i < ZJDefaultColumnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.ColumnHeights[i] doubleValue];
        //一旦发现有一列高度比最小的高度还小，则把这个高度纪录在minColumnHeight上，然后纪录下最短高度的i
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }
    
    return CGSizeMake(0, maxColumnHeight + ZJDefaultEdgeInsets.bottom);
}

@end
