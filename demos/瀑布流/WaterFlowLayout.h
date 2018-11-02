//
//  WaterFlowLayout.h
//  demos
//
//  Created by jack on 2018/10/29.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterFlowLayoutDelegate;

@interface WaterFlowLayout : UICollectionViewLayout
@property (assign,nonatomic)CGFloat columnMargin;//每一列item之间的间距
@property (assign,nonatomic)CGFloat rowMargin;   //每一行item之间的间距
@property (assign,nonatomic)UIEdgeInsets sectionInset;//设置于collectionView边缘的间距
@property (assign,nonatomic)NSInteger columnCount;//设置每一行排列的个数


@property (weak,nonatomic)id<WaterFlowLayoutDelegate> delegate; //设置代理

@end
@protocol WaterFlowLayoutDelegate

-(CGFloat)waterFlowLayout:(WaterFlowLayout *) WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath;
@end
