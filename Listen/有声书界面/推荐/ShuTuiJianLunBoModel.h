//
//  ShuTuiJianLunBoModel.h
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuTuiJianLunBoModel : NSObject
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger albumId;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
