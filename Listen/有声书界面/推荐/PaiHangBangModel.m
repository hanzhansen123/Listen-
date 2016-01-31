//
//  PaiHangBangModel.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "PaiHangBangModel.h"

@implementation PaiHangBangModel
- (instancetype)initWithDic:(NSDictionary *)dic
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
