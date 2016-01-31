//
//  TopTableViewCell.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopModel.h"

@interface TopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UIImageView *UIimageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *FenLeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *JiLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) TopModel *model;

@end
