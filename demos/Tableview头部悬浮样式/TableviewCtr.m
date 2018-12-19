//
//  TableviewCtr.m
//  demos
//
//  Created by jack on 2018/11/21.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "TableviewCtr.h"

@interface TableviewCtr ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArrayM;

@property (nonatomic, copy) NSMutableArray *arr;
@property (nonatomic, strong)  UIView * head;
@property (nonatomic, strong) UIView * headd;
@end

@implementation TableviewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleArrayM=@[@"直播demo",@"观看直播demo",@"导航栏渐变demo",@"下拉放大拉伸效果demo",@"JS和OC交互demo",@"频道管理demo",@"自定义弹窗",@"频道管理demo",@"自定义弹窗",@"频道管理demo",@"自定义弹窗",@"频道管理demo",@"自定义弹窗",@"频道管理demo",@"自定义弹窗"].mutableCopy;
    
    self.title = @"头部悬浮";
    [self.view addSubview:self.tableView];
    
    _head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    _head.backgroundColor=[UIColor yellowColor];
    
    
    _headd=[[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 40)];
    _headd.backgroundColor=[UIColor redColor];
    [_head addSubview:_headd];
    
    
//    [self.view addSubview:_head];
    self.tableView.tableHeaderView=_head;
}


#pragma mark - UITableViewDelegate  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView * headd=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    headd.backgroundColor=[UIColor redColor];
//
//    return headd;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArrayM.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.text = self.titleArrayM[indexPath.row];
    
    return cell;
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<60) {
//        scrollView.contentInset=UIEdgeInsetsMake(scrollView.contentOffset.y, 0, 0, 0);
       
        
        [_headd removeFromSuperview];
        _headd.frame=CGRectMake(0, 60, self.view.frame.size.width, 40);
        [_head addSubview:_headd];
//        _tableView.tableHeaderView=_head;
        
    }else  if(scrollView.contentOffset.y>60){
        
        [_headd removeFromSuperview];
        _headd.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
        [self.view addSubview:_headd];
    }
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
