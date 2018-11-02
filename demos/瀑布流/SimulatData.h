//
//  SimulatData.h
//  demos
//
//  Created by jack on 2018/11/2.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PersonListLogicDelegate <NSObject>
@optional
/**
 数据加载完成
 */
-(void)requestDataCompleted;

@end

@interface SimulatData : NSObject

@property (nonatomic,strong) NSMutableArray * dataArray;//数据源
@property (nonatomic,assign) NSInteger  page;//页码

@property(nonatomic,weak)id<PersonListLogicDelegate> delegagte;

/**
 拉取数据
 */
-(void)loadData;
@end
