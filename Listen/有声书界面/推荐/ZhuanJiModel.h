//
//  ZhuanJiModel.h
//  Listen
//
//  Created by laouhn on 15/11/19.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuanJiModel : NSObject
//MP3
@property (nonatomic, copy) NSString *playUrl64;
//标题
@property (nonatomic, copy) NSString *title;
//播放次数
@property (nonatomic, assign) NSInteger playtimes;
//评论数
@property (nonatomic, assign) NSInteger comments;
//持续时间
@property (nonatomic, assign) NSInteger duration;
//图片url
@property (nonatomic, copy) NSString *coverMiddle;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
