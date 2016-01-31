//
//  PaiHangBangModel.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiHangBangModel : NSObject
//cell的标题
@property (nonatomic, copy) NSString *title;
//cell的简介
@property (nonatomic, copy) NSString *subtitle;
//图片
@property (nonatomic, copy) NSString *coverPath;
//key
@property (nonatomic, copy) NSString *key;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
