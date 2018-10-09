//
//  DropDownEffectCtr.m
//  demos
//
//  Created by jack on 2018/8/28.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "DropDownEffectCtr.h"
static CGFloat headerImgHeight = 278.5;

@interface DropDownEffectCtr ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArrayM;
@property (nonatomic, strong)UIImageView *headView;


@end

@implementation DropDownEffectCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    _headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 278.5)];
    [_headView setImage:[UIImage imageNamed:@"topBG"]];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
   
    self.titleArrayM=@[@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果",@"下拉放大拉伸效果"].mutableCopy;
    
    self.title = @"下拉放大拉伸效果";
    [self.view addSubview:self.tableView];
     [self.view addSubview:_headView];
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 278.5, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    CGFloat yOffset   =scrollView.contentOffset.y;
    

    if (yOffset <0) {
        CGFloat scale =  self.headView.frame.size.width / self.headView.frame.size.height;
        CGFloat imgH = headerImgHeight - scrollView.contentOffset.y ;
        CGFloat imgW = imgH * scale;
        self.headView.frame = CGRectMake(scrollView.contentOffset.y * scale/2,0, imgW,imgH);
    } else {
        CGRect f =self.headView.frame;
        f.origin.y =0;
        self.headView.frame = f;
    }
    
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
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
