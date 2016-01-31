//
//  RootViewController.m
//  CeShiButton
//
//  Created by laouhn on 15/11/13.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#import "RootViewController.h"
#import "DCPathButton.h"
#import "YouShengShuViewController.h"
#import "YinYueViewController.h"
#import "XiangShengViewController.h"

@interface RootViewController () <DCPathButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *AnimationImage;
@property (nonatomic , strong) DCPathButton *pathAnimationView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景雨滴动画
    [self BeginAnimationImage];
    
    //设置加号按钮
    [self pathAnimation];
}

#pragma mark - 背景雨滴动画 -
- (void)BeginAnimationImage
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < 11; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02d.png", i] ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [arr addObject:image];
    }
    self.AnimationImage.alpha = 1.0;
    self.AnimationImage.animationImages = arr;
    self.AnimationImage.animationDuration = 0.6;
    self.AnimationImage.animationRepeatCount = 0;
    [self.AnimationImage startAnimating];
}

/**
 *  仿Path 菜单动画
 */
-(void)pathAnimation{
    if (!_pathAnimationView) {
        [self ConfigureDCPathButton];
    }else{
        _pathAnimationView.hidden = NO;
    }
}

//给选择按钮设置图片
- (void)ConfigureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    _pathAnimationView = dcPathButton;
    
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"shu"]
                                                           highlightedImage:[UIImage imageNamed:@"gaoliangshu"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"KuaiBan"]
                                                           highlightedImage:[UIImage imageNamed:@"gaoliangKuaiBan"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"baijiajiangtan"]
                                                           highlightedImage:[UIImage imageNamed:@"gaoliangbaijiajiangtan"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"guangboju"]
                                                           highlightedImage:[UIImage imageNamed:@"gaoliangguangboju"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    dcPathButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height-30);
    [self.view addSubview:dcPathButton];
}

#pragma mark - DCPathButton Delegate 选择进入不同界面
- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            [self performSegueWithIdentifier:@"YouShengShu" sender:self];
        }
            break;
        case 1:
        {
             [self performSegueWithIdentifier:@"YinYue" sender:self];
            
        }
            break;
        case 2:
        {
             [self performSegueWithIdentifier:@"XiangSheng" sender:self];
            
        }
            break;
        case 3:
        {
            [self performSegueWithIdentifier:@"BaiJiaJiangTan" sender:self];
            
        }
            break;
        case 4:
        {
            [self performSegueWithIdentifier:@"GuangBoJu" sender:self];
            
        }
            break;
            
        default:
            break;
    }
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
