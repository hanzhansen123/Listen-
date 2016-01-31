//
//  ZhuanJiHeaderModel.m
//  Listen
//
//  Created by laouhn on 15/11/19.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "ZhuanJiHeaderModel.h"

@implementation ZhuanJiHeaderModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
