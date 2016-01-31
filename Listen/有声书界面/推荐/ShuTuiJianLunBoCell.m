//
//  ShuTuiJianLunBoCell.m
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "ShuTuiJianLunBoCell.h"
#import "UIImageView+WebCache.h"

@implementation ShuTuiJianLunBoCell

- (void)setModel:(ShuTuiJianLunBoModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    self.imageView.userInteractionEnabled = YES;
}

@end
