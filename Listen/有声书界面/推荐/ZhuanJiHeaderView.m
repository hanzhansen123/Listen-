//
//  ZhuanJiHeaderView.m
//  Listen
//
//  Created by laouhn on 15/11/18.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "ZhuanJiHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation ZhuanJiHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZhuanJiHeaderView" owner:nil options:nil] lastObject];
        [self setSubView];
    }
    return self;
}

- (void)setSubView
{
    //设置标签1边框， 并添加圆角
    self.biaoQian1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.biaoQian1.layer.borderWidth = 0.5f;
    self.biaoQian1.layer.masksToBounds = YES;
    self.biaoQian1.layer.cornerRadius = 12.0;
    //设置标签2边框， 并添加圆角
    self.biaoQian2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.biaoQian2.layer.borderWidth = 0.5f;
    self.biaoQian2.layer.masksToBounds = YES;
    self.biaoQian2.layer.cornerRadius = 12.0;
    
}

- (void)setModel:(ZhuanJiHeaderModel *)model
{
    _model = model;
    
    self.titleLable.text = model.title;
    [self.daImageView sd_setImageWithURL:[NSURL URLWithString:model.coverMiddle] placeholderImage:nil];
    [self.xiaoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarPath] placeholderImage:nil];
    self.zuoZheLable.text = model.nickname;
    self.jianJieLabel.text = model.intro;
    //设置作者头像圆角
    self.xiaoImageView.layer.masksToBounds = YES;
    self.xiaoImageView.layer.cornerRadius = self.xiaoImageView.bounds.size.width/2.0;

    //如果没有值， 则隐藏标签
    if (!model.tags) {
        
        self.biaoQian1.hidden = YES;
        self.biaoQian2.hidden = YES;
    }else
    {
        //截取标签字符串， 并给标签赋值
        NSString *biaoqian = model.tags;
        NSRange range1 = [biaoqian rangeOfString:@","];
        
        if (range1.location == NSNotFound) {
            self.biaoQian1.text = biaoqian;
            self.biaoQian2.hidden = NO;
        }else if (range1.length > 0){
        NSString *biaoqian1 = [biaoqian substringToIndex:range1.location];
        //为第一个标签赋值
        self.biaoQian1.text = biaoqian1;
            
            NSString *shengYuStr = [biaoqian substringFromIndex:range1.location+range1.length];
            
            //判断是否存在第二个逗号
            NSRange range = [shengYuStr rangeOfString:@","];
            if (range.location == NSNotFound) {
                self.biaoQian2.hidden = YES;
            }
            if (range.length > 0) {
                NSRange range2 = [shengYuStr rangeOfString:@","];
                NSString *biaoqian2 = [shengYuStr substringToIndex:range2.location];
                self.biaoQian2.text = biaoqian2;
            }
        }
        
    }
}

@end
