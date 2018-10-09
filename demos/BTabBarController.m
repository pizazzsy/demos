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

@interface BTabBarController ()

@end

@implementation BTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    WKWebViewCtr *webv = [[WKWebViewCtr alloc] init];
    
      [webv.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mallapi.tyxin.cn/dist/index.html#/home"]]];
    
    UINavigationController *nwvc = [[UINavigationController alloc]initWithRootViewController:webv];
    
  self.viewControllers = @[nvc, nwvc];
    UITabBarItem *aItem = [[UITabBarItem alloc] initWithTitle:@"咨询" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    aItem.selectedImage = [[UIImage imageNamed:@""]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [aItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    UITabBarItem *bItem = [[UITabBarItem alloc] initWithTitle:@"设备" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    bItem.selectedImage = [[UIImage imageNamed:@""]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [bItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    nvc.tabBarItem = bItem;
    nwvc.tabBarItem = aItem;
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
