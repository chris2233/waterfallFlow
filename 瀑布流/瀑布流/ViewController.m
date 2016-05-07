//
//  ViewController.m
//  瀑布流
//
//  Created by 张杰 on 16/5/6.
//  Copyright © 2016年 zhangjie. All rights reserved.
//

#import "ViewController.h"
#import "ZJWaterflow.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

static NSString *const ZJShopId = @"shop";
- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建布局
    ZJWaterflow *layout = [[ZJWaterflow alloc]init];
    
    //创建collectionview
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZJShopId];
    
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZJShopId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    NSInteger tag = 10;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%zd",indexPath.item];
    [label sizeToFit];
    return cell;
}

@end
