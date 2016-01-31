//
//  PaiHangCell.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "PaiHangCell.h"

@implementation PaiHangCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"PaiHangCell";
    PaiHangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PaiHangCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
