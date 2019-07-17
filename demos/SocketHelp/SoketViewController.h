//
//  SoketViewController.h
//  demos
//
//  Created by ra on 2019/4/1.
//  Copyright © 2019年 tianyixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoketViewController : UIViewController
typedef void (^udpSocketBlock)(NSDictionary* dic,NSError* err);// block用于硬件返回信息的回调
@property (nonatomic,copy) udpSocketBlock udpSocketBlock;
- (void)sendUdpBoardcast:(udpSocketBlock)block;
@end

NS_ASSUME_NONNULL_END
