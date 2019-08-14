//
//  ViewController.m
//  demos
//
//  Created by jack on 2018/8/27.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "ViewController.h"
#import "ColorGradientDemoViewController.h"
#import "WKWebViewCtr.h"
#import "DropDownEffectCtr.h"
#import "ProgramManageCtr.h"
#import "CustomAlterCtr.h"
#import "TableviewCtr.h"
#import "DropDownMenuViewController.h"
#import "SoketViewController.h"
#import "FileOperationCtr.h"
#import "ChatViewController.h"
#import "BlueToothLinkViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArrayM;

@property (nonatomic, copy) NSMutableArray *arr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleArrayM=@[@"wifidemo",@"下拉列表demo",@"导航栏渐变demo",@"下拉放大拉伸效果demo",@"JS和OC交互demo",@"频道管理demo",@"自定义弹窗",@"tableview头部悬浮",@"文件读取",@"即时聊天",@"蓝牙连接"].mutableCopy;
    
    self.title = @"Demos";
    [self.view addSubview:self.tableView];
    
    
    
//    UIButton*anniu=[UIButton buttonWithType:UIButtonTypeSystem];
//    [anniu setFrame:CGRectMake(10, 400, 100, 30)];
//    [anniu setTitle:@"anniu" forState:0];
//    [anniu addTarget:self action:@selector(anniu) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:anniu];
    
    // Do any additional setup after loading the view, typically from a nib.
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[[SoketViewController alloc]init] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[[DropDownMenuViewController alloc]init] animated:YES];
        }
            break;
        case 2:
        {
            
            [self.navigationController pushViewController:[[ColorGradientDemoViewController alloc]init] animated:YES];
        }
            break;
        case 3:
        {
             [self.navigationController pushViewController:[[DropDownEffectCtr alloc]init] animated:YES];
        }
            break;
        case 4:
        {
            
            [self.navigationController pushViewController:[[WKWebViewCtr alloc]init] animated:YES];
        }
            break;
        case 5:
        {
            
            [self.navigationController pushViewController:[[ProgramManageCtr alloc]init] animated:YES];
        }
            break;
        case 6:
        {
            
            [self.navigationController pushViewController:[[CustomAlterCtr alloc]init] animated:YES];
        }
            break;
        case 7:
        {
            
            [self.navigationController pushViewController:[[TableviewCtr alloc]init] animated:YES];
        }
            break;
        case 8:
        {
            [self.navigationController pushViewController:[[FileOperationCtr alloc]init] animated:YES];
        }
            break;
        case 9:
        {
            ChatViewController*chatCtr=[[ChatViewController alloc]init];
//            //设置要显示的会话类型
//            [chatCtr setDisplayConversationTypes:@[
//                                                @(ConversationType_PRIVATE),
//                                                @(ConversationType_DISCUSSION),
//                                                @(ConversationType_APPSERVICE),
//                                                @(ConversationType_PUBLICSERVICE),
//                                                @(ConversationType_GROUP),
//                                                @(ConversationType_SYSTEM)
//                                                ]];
//            //聚合会话类型
//            [chatCtr setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
            chatCtr.isEnteredToCollectionViewController = YES;
            [self.navigationController pushViewController:chatCtr animated:YES];
            
            
            
        }
        case 10:{
            [self.navigationController pushViewController:[[BlueToothLinkViewController alloc]init] animated:YES ];
        }
            break;
            
        default:
            break;
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
