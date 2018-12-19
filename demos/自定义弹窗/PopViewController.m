//
//  PopViewController.m
//  demos
//
//  Created by jack on 2018/11/21.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()
@property(strong,nonatomic)UIView * bgview;
@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgview=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bgview];
    self.bgview.backgroundColor=[UIColor redColor];

    // Do any additional setup after loading the view.
}
-(void)viewWillLayoutSubviews{
    self.bgview.frame=CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height/2);
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
