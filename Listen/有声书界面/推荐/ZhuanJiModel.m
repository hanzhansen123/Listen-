//
//  ZhuanJiModel.m
//  Listen
//
//  Created by laouhn on 15/11/19.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "ZhuanJiModel.h"

@implementation ZhuanJiModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"images"]) {
        NSArray *imageArr = value;
        self.coverMiddle = imageArr.firstObject;
    }
}

@end
