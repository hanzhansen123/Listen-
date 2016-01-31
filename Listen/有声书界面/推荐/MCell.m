//
//  MCell.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "MCell.h"
#import "UIImageView+WebCache.h"

@implementation MCell

+ (instancetype)cellWithTable:(UITableView *)tableView
{
    static NSString *identifier = @"MCell";
    MCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ShuTuiJianModel *)model
{
    _model = model;
    self.Title.text = model.title;
    self.JianJie.text = model.intro;
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.coverMiddle] placeholderImage:nil];
    CGFloat number = model.playsCounts / 10000.0;
    self.PlayNum.text = [NSString stringWithFormat:@"▷%.1f 万", number];
    self.JiShu.text = [NSString stringWithFormat:@"§%ld 集", (long)model.tracksCounts];
}

@end
