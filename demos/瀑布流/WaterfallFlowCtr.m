//
//  WaterfallFlowCtr.m
//  demos
//
//  Created by jack on 2018/10/29.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "WaterfallFlowCtr.h"
#import "WaterFlowLayout.h"
#import "WaterfallFlowCell.h"
#import "SimulatData.h"

#define itemWidthHeight ((kScreenWidth-30)/2)
@interface WaterfallFlowCtr ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate,PersonListLogicDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) SimulatData *logic;//逻辑层
@end

@implementation WaterfallFlowCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"瀑布流";
    //初始化逻辑类
    _logic = [SimulatData new];
    _logic.delegagte = self;
    [self initUI];
     [self.collectionView.mj_header beginRefreshing];
}
-(void)initUI{
    //设置瀑布流布局
    WaterFlowLayout *layout = [WaterFlowLayout new];
    layout.columnCount = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);;
    layout.rowMargin = 10;
    layout.columnMargin = 10;
    layout.delegate = self;
    
    //1.初始化layout
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
//    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake(110, 150);
    
  
    
    
    self.collectionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight - kTabBarHeight);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = CViewBgColor;
    [self.collectionView registerClass:[WaterfallFlowCell class] forCellWithReuseIdentifier:NSStringFromClass([WaterfallFlowCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [_logic loadData];
}

#pragma mark ————— 上拉刷新 —————
-(void)footerRereshing{
    _logic.page+=1;
    [_logic loadData];
}

#pragma mark ————— 数据拉取完成 渲染页面 —————
-(void)requestDataCompleted{
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    
    //    [UIView performWithoutAnimation:^{
    [self.collectionView reloadData];
    //    }];
    
}
#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _logic.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaterfallFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WaterfallFlowCell class]) forIndexPath:indexPath];
    cell.personModel = _logic.dataArray[indexPath.row];
    
    return cell;
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    //创建模拟数据
//    PersonModel *personModel = _logic.dataArray[indexPath.row];
//    if (personModel.hobbys && personModel.hobbysHeight == 0) {
//        //计算hobby的高度 并缓存
//        CGFloat hobbyH=[personModel.hobbys heightForFont:FFont1 width:(KScreenWidth-30)/2-20];
//        if (hobbyH>43) {
//            hobbyH=43;
//        }
//        personModel.hobbysHeight = hobbyH;
//    }
//    CGFloat imgH = personModel.height * itemWidthHeight / personModel.width;
//
////    return imgH + 110 + personModel.hobbysHeight;
//
//     return CGSizeMake(170, imgH + 110 + personModel.hobbysHeight);
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}
//
////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
//
////设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 15;
//}

#pragma mark ————— layout 代理 —————
-(CGFloat)waterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath{
    
    //创建模拟数据
    PersonModel *personModel = _logic.dataArray[indexPath.row];
    if (personModel.hobbys && personModel.hobbysHeight == 0) {
        //计算hobby的高度 并缓存
        CGFloat hobbyH=[personModel.hobbys heightForFont:FFont1 width:(KScreenWidth-30)/2-20];
        if (hobbyH>43) {
            hobbyH=43;
        }
        personModel.hobbysHeight = hobbyH;
    }
    CGFloat imgH = personModel.height * itemWidthHeight / personModel.width;
    
    return imgH + 110 + personModel.hobbysHeight;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
