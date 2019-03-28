//
//  DropDownMenuViewController.m
//  demos
//
//  Created by ra on 2019/3/25.
//  Copyright © 2019年 tianyixin. All rights reserved.
//

#import "DropDownMenuViewController.h"
#import "DropdownMenu.h"

@interface DropDownMenuViewController ()<DropdownMenuDelegate>
{
    
}
@end

@implementation DropDownMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    DropdownMenu*MenuBtn = [[DropdownMenu alloc] initWithFrame:CGRectMake(RealValue(50), RealValue(100), RealValue(180), RealValue(30)) andTitle:@"请选择"];
    [MenuBtn setMenuTitles:@[@"选择一",@"选择二",@"选择三"] rowHeight:RealValue(50)];
    MenuBtn.mainBtn.layer.borderColor=[UIColor colorWithHexString:@"e9e9e9"].CGColor;
    MenuBtn.mainBtn.layer.cornerRadius=5;
    MenuBtn.tag=1000;
    MenuBtn.delegate = self;
    [self.view addSubview:MenuBtn];
    
    // Do any additional setup after loading the view.
}

-(void)dropdownMenu:(DropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"选中了第%ld行",(long)number);
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
