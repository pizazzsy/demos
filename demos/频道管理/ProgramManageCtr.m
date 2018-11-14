//
//  ProgramManageCtr.m
//  demos
//
//  Created by jack on 2018/11/9.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "ProgramManageCtr.h"
#import "TestCell.h"
#import "WaterFlowLayout.h"
#import "WaterfallFlowCell.h"
#import "SimulatData.h"

#define ColumnNumber 4
#define CellMarginX 5
#define CellMarginY 5

@interface ProgramManageCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView*_collectionView;
    UIView * _dragingCell;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    

}
@end

@implementation ProgramManageCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"频道管理demo";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];
}
-(void)initUI{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    CGFloat cellWidth=(self.view.bounds.size.width- (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
  
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:@"TestCell"];
     [self.collectionView registerClass:[WaterfallFlowCell class] forCellWithReuseIdentifier:NSStringFromClass([WaterfallFlowCell class])];
     [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2.0f)];
    _dragingCell.hidden = true;
    _dragingCell.backgroundColor=[UIColor yellowColor];
    
    [_collectionView addSubview:_dragingCell];
 
    
    
 
}
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:gesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:gesture];
            break;
        default:
            break;
    }
}

-(void)dragBegin:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    NSLog(@"拖拽开始 indexPath = %@",_dragingIndexPath);
    [_collectionView bringSubviewToFront:_dragingCell];
    //更新被拖拽的cell
    _dragingCell.frame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    _dragingCell.hidden = false;
    [UIView animateWithDuration:0.3 animations:^{
        [_dragingCell setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }];
}

//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point
{
    NSIndexPath* dragingIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in [_collectionView indexPathsForVisibleItems]) {
        //判断cell是否包含这个点
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragingIndexPath = indexPath;
            break;
        }
    }
    return dragingIndexPath;
}
//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point
{
    NSIndexPath *targetIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //避免和当前拖拽的cell重复
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //判断是否包含这个点
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            targetIndexPath = indexPath;
        }
    }
    return targetIndexPath;
}

-(void)dragChanged:(UILongPressGestureRecognizer*)gesture{
    NSLog(@"拖拽中。。。");
    CGPoint point = [gesture locationInView:_collectionView];
    _dragingCell.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    NSLog(@"targetIndexPath = %@",_targetIndexPath);
    if (_targetIndexPath && _dragingIndexPath) {
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}
-(void)dragEnd:(UILongPressGestureRecognizer*)gesture{
    NSLog(@"拖拽结束");
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        _dragingCell.frame = endFrame;
    }completion:^(BOOL finished) {
        _dragingCell.hidden = true;
    }];
}



#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
   
    
    cell.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
