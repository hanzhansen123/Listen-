//
//  ShuTuiJianModel.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuTuiJianModel : NSObject
@property (nonatomic, copy) NSString *ID;
//图标
@property (nonatomic, copy) NSString *coverMiddle;
//标题
@property (nonatomic, copy) NSString *title;
//简介
@property (nonatomic, copy) NSString *intro;
//播放次数
@property (nonatomic, assign) NSInteger playsCounts;
//集
@property (nonatomic, assign) NSInteger tracksCounts;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
