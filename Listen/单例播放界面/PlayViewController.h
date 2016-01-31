//
//  PlayViewController.h
//  Listen
//
//  Created by laouhn on 15/11/16.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanJiModel.h"

@interface PlayViewController : UIViewController

+ (instancetype)sharePlayVC;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ZhuanJiModel *model;
@property (nonatomic, assign) NSInteger indexNum;


@end
