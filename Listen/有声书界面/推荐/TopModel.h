//
//  TopModel.h
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopModel : NSObject
//id
@property (nonatomic, copy) NSString *ID;
//标题
@property (nonatomic, copy) NSString *title;
//分类
@property (nonatomic, copy) NSString *tags;
//图片
@property (nonatomic, copy) NSString *coverMiddle;
//集
@property (nonatomic, assign) NSInteger tracksCounts;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
