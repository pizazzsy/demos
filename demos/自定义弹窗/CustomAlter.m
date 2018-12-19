//
//  CustomAlter.m
//  TianYiXinForDoctors
//
//  Created by jack on 2017/12/11.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "CustomAlter.h"
@interface CustomAlter()

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIView *alertView;
@property(nonatomic,strong)UIButton *sureBtn;
@end
@implementation CustomAlter

- (instancetype)initWithWidth:(CGFloat)width ImageStr:(NSString*)imgstr SureBtn:(NSString*)sureBtn SureBtnImg:(NSString*)sureBtnImg
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        
        
        
        UIImage * bgimg=[UIImage imageNamed:imgstr];
        CGFloat scale=bgimg.size.width/bgimg.size.height;
        
        CGFloat AlWidth=width;
        CGFloat AlHight=AlWidth/scale;
        
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlWidth, AlHight)];
        self.alertView.backgroundColor = [UIColor clearColor];
        self.alertView.layer.position = self.center;
    
        
        _bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AlWidth, AlWidth/scale)];
        _bgView.image=bgimg;
        
        [self.alertView addSubview:_bgView];
        
    
        if (sureBtn) {
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(_bgView.frame), AlWidth, 40);
            self.sureBtn.tag=1001;
            self.sureBtn.backgroundColor=[UIColor redColor];
            [self.sureBtn setTitle:sureBtn forState:UIControlStateNormal];
            
            [self.sureBtn addTarget:self action:@selector(ClickBut:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.alertView addSubview:self.sureBtn];
        }
        
        
        //计算高度
        CGFloat alertHeight = CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlWidth, alertHeight);
        self.alertView.layer.position = self.center;
        [self addSubview:self.alertView];
    }
    
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [self.bgView removeFromSuperview];
    //    self.bgView = nil;
        [self removeFromSuperview];
}
-(void)clicks{
    NSLog(@"4213123");
}
#pragma mark ====展示view
- (void)showView
{
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    self.bgView.userInteractionEnabled = YES;
//    self.bgView.backgroundColor = [UIColor blackColor];
//    self.bgView.alpha = 0.4;
    [window addSubview:self];
    
}
- (void)ClickBut:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnClickAtIndex:)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate btnClickAtIndex:sender.tag - 1000];
    }
}

- (void)closeView
{
//    [self.bgView removeFromSuperview];
//    self.bgView = nil;
    [self removeFromSuperview];
}

@end
