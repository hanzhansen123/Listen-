//
//  ShuTuiJianLunBoCell.h
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuTuiJianLunBoModel.h"

@interface ShuTuiJianLunBoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) ShuTuiJianLunBoModel *model;
@end
