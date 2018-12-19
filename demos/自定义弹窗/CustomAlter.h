//
//  CustomAlter.h
//  TianYiXinForDoctors
//
//  Created by jack on 2017/12/11.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomAlterDelegate <NSObject>//协议

- (void)btnClickAtIndex:(NSInteger)index;//协议方法

@end
@interface CustomAlter : UIView
@property (nonatomic, assign) id<CustomAlterDelegate>delegate;//代理属性
-(instancetype)initWithWidth:(CGFloat)width ImageStr:(NSString*)imgstr SureBtn:(NSString*)sureBtn SureBtnImg:(NSString*)sureBtnImg;
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
-(void)showView;
-(void)closeView;
@end
