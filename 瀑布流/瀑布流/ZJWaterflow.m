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
//存放内容的高度
@property (assign, nonatomic) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;


@end

@implementation ZJWaterflow

#pragma mark - 代理方法处理

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginForwaterflow:)]) {
        return [self.delegate rowMarginForwaterflow:self];
    }else {
        return ZJDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginForwaterflow:)]) {
        return [self.delegate columnMarginForwaterflow:self];
    }else {
        return ZJDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountForwaterflow:)]) {
        return [self.delegate columnCountForwaterflow:self];
    }else {
        return ZJDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsForwaterflow:)]) {
        return [self.delegate edgeInsetsForwaterflow:self];
    }else {
        return ZJDefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
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
    //清除内容的高度
    self.contentHeight = 0;
    
    //清除数组里的所有高度
    [self.ColumnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        self.ColumnHeights[i] = @(self.edgeInsets.top);
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
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (ZJDefaultColumnCount-1)*self.columnMargin)/ZJDefaultColumnCount;

    //找到哪一列的高度最短
    NSInteger destColumn = 0 ;
    CGFloat minColumnHeight = [self.ColumnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.ColumnHeights[i] doubleValue];
        //一旦发现有一列高度比最小的高度还小，则把这个高度纪录在minColumnHeight上，然后纪录下最短高度的i
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    //解除高度和数据源的依赖关系
    CGFloat h = [self.delegate waterflow:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    CGFloat x = self.edgeInsets.left + (w + self.columnMargin) * destColumn;
    CGFloat y = minColumnHeight;
    
    if(y != self.edgeInsets.top)
    {
        y += self.rowMargin;
    }
    //设置布局的属性
    attrs.frame = CGRectMake(x, y, w, h);
    
    //更新最短哪一列的高度
    self.ColumnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    CGFloat columnHeight = [self.ColumnHeights[destColumn] doubleValue];
    //如果整体的高度是小于当前最长列的高度的话，就把高度保存这个属性中
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

-(CGSize)collectionViewContentSize
{
    
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
