//
//  BTabBarController.m
//  demos
//
//  Created by jack on 2018/9/27.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "BTabBarController.h"
#import "ViewController.h"
#import "WKWebViewCtr.h"
#import "WaterfallFlowCtr.h"

@interface BTabBarController ()

@end

@implementation BTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc = [[ViewController alloc] init];
    baseNavigationController *nvc = [[baseNavigationController alloc]initWithRootViewController:vc];
    WaterfallFlowCtr *bv = [[WaterfallFlowCtr alloc] init];
    
    
    
    baseNavigationController *nwvc = [[baseNavigationController alloc]initWithRootViewController:bv];
    
  self.viewControllers = @[nvc, nwvc];
    UITabBarItem *aItem = [[UITabBarItem alloc] initWithTitle:@"Demo" image:[UIImage imageNamed:@"icon_tabbar_onsite"] selectedImage:[UIImage imageNamed:@"icon_tabbar_onsite_selected"]];
    aItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_onsite_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    UITabBarItem *bItem = [[UITabBarItem alloc] initWithTitle:@"瀑布流" image:[UIImage imageNamed:@"icon_tabbar_merchant_normal"] selectedImage:[UIImage imageNamed:@"icon_tabbar_merchant_selected"]];
    bItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [bItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    nvc.tabBarItem = aItem;
    nwvc.tabBarItem = bItem;
    // Do any additional setup after loading the view.
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
