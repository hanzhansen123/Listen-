//
//  TopTableViewCell.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "TopTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TopTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"TopTableViewCell";
    TopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(TopModel *)model
{
    _model = model;
    [self.UIimageView sd_setImageWithURL:[NSURL URLWithString:model.coverMiddle] placeholderImage:nil];
    self.titleLabel.text = model.title;
    NSString *str = model.tags;
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    self.FenLeiLabel.text = newStr;
    self.JiLabel.text = [NSString stringWithFormat:@"%ld", model.tracksCounts];
}

@end
