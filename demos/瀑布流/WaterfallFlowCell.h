//
//  WaterfallFlowCell.h
//  demos
//
//  Created by jack on 2018/10/29.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@interface WaterfallFlowCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgView;
@property(nonatomic,strong)PersonModel *personModel;
@end
