//
//  ZhuanJiXiangQingTableViewCell.h
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuanJiModel.h"

@interface ZhuanJiXiangQingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *boFangCiShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShiChangLabel;
@property (weak, nonatomic) IBOutlet UILabel *PingLunLabel;


@property (nonatomic, strong) ZhuanJiModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
