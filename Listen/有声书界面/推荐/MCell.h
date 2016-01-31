//
//  MCell.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuTuiJianModel.h"

@interface MCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *Title;
//简介
@property (weak, nonatomic) IBOutlet UILabel *JianJie;
//播放次数
@property (weak, nonatomic) IBOutlet UILabel *PlayNum;
//集
@property (weak, nonatomic) IBOutlet UILabel *JiShu;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (nonatomic, strong) ShuTuiJianModel *model;

+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
