//
//  ZhuanJiHeaderView.h
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanJiHeaderModel.h"

@interface ZhuanJiHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *daImageView;
@property (weak, nonatomic) IBOutlet UIImageView *xiaoImageView;
@property (weak, nonatomic) IBOutlet UILabel *zuoZheLable;
@property (weak, nonatomic) IBOutlet UILabel *jianJieLabel;
@property (weak, nonatomic) IBOutlet UILabel *biaoQian1;
@property (weak, nonatomic) IBOutlet UILabel *biaoQian2;

@property (nonatomic, strong) ZhuanJiHeaderModel *model;

@end
