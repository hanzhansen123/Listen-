//
//  ZhuanJiXiangQingTableViewCell.m
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "ZhuanJiXiangQingTableViewCell.h"

@implementation ZhuanJiXiangQingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *XiangQingCell = @"XiangQingCell";
    ZhuanJiXiangQingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XiangQingCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZhuanJiXiangQingTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ZhuanJiModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.boFangCiShuLabel.text = [NSString stringWithFormat:@"▷ %ld", (long)model.playtimes];
    self.ShiChangLabel.text = [NSString stringWithFormat:@"⊹ %d:%d", model.duration / 60, model.duration % 60];
    self.PingLunLabel.text = [NSString stringWithFormat:@"♡ %ld", (long)model.comments];
}

@end
