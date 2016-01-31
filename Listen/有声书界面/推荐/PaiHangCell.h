//
//  PaiHangCell.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiHangBangModel.h"

@interface PaiHangCell : UITableViewCell

@property (nonatomic, strong) PaiHangBangModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
