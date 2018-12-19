//
//  CustomAlterCtr.m
//  demos
//
//  Created by jack on 2018/11/16.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "CustomAlterCtr.h"
#import "Masonry.h"
#import "CustomAlter.h"
#import "PopViewController.h"

@interface CustomAlterCtr ()<UIPopoverPresentationControllerDelegate>
@property(strong,nonatomic)  UIButton *AlterBtn;
@end

@implementation CustomAlterCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _AlterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_AlterBtn setTitle:@"弹出视图" forState:(UIControlStateNormal)];
    [_AlterBtn setBackgroundColor:[UIColor yellowColor]];
    [_AlterBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [_AlterBtn addTarget:self action:@selector(ClickBut:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:_AlterBtn];
    [_AlterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    
    }];
    // Do any additional setup after loading the view.
}
-(void)ClickBut:(UIButton*)sender{
//    CustomAlter *alter=[[CustomAlter alloc]initWithWidth:300 ImageStr:@"haha" SureBtn:@"确定" SureBtnImg:nil];
//    [alter showView];
    
    //  初始化弹出控制器
    PopViewController *vc = [PopViewController new];
    //  背景色
    vc.view.backgroundColor = [UIColor yellowColor];
    //  弹出视图的显示样式
    vc.modalPresentationStyle = UIModalPresentationPopover;
    //  1、弹出视图的大小
    vc.preferredContentSize = CGSizeMake(100, 100);
    //  弹出视图的代理
    vc.popoverPresentationController.delegate = self;
    //  弹出视图的参照视图、从哪弹出
    vc.popoverPresentationController.sourceView = _AlterBtn;
    //  弹出视图的尖头位置：参照视图底边中间位置
    vc.popoverPresentationController.sourceRect = _AlterBtn.bounds;
    //  弹出视图的箭头方向
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //  弹出
    [self presentViewController:vc animated:YES completion:nil];
   
    

}


- (BOOL) popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    return YES;
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
    
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    NSLog(@"dismissed");
    
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
