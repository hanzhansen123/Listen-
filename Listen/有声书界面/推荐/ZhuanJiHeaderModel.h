//
//  ZhuanJiHeaderModel.h
//  Listen
//
//  Created by laouhn on 15/11/19.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuanJiHeaderModel : NSObject

@property (nonatomic, copy) NSString *title;
//图片URL
@property (nonatomic, copy) NSString *coverMiddle;
//作者
@property (nonatomic, copy) NSString *nickname;
//作者图片
@property (nonatomic, copy) NSString *avatarPath;
//简介
@property (nonatomic, copy) NSString *intro;
//标签
@property (nonatomic, copy) NSString *tags;
//集数
@property (nonatomic, assign) NSInteger tracks;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
