//
//  YouShengShuViewController.m
//  CeShiButton
//
//  Created by laouhn on 15/11/14.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#define kScreenW self.view.frame.size.width
#define kScreenH self.view.frame.size.height

#import "YouShengShuViewController.h"
#import "HTHorizontalSelectionList.h"
#import "ShuTuiJianViewController.h"
#import "UIColor+BackgroundColor.h"
#import "LangManYanQingViewController.h"
#import "PlayViewController.h"

@interface YouShengShuViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) HTHorizontalSelectionList *SelectList;
@property (nonatomic, strong) NSArray *ListArray;
@property (nonatomic, assign) CGFloat contentW;
@property (nonatomic, assign) BOOL isLeft;
@end

@implementation YouShengShuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //布局选择列表视图
    [self layoutSelectionListView];
    
    //布局scrollView
    [self layoutScrollView];
}

//布局选择列表视图
- (void)layoutSelectionListView
{
    self.SelectList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 40)];
    self.SelectList.delegate = self;
    self.SelectList.dataSource = self;
    self.ListArray = @[@"推荐", @"玄幻奇幻", @"浪漫言情", @"青春校园", @"历史军事", @"恐怖悬疑", @"穿越架空", @"武侠仙侠", @"文学名著", @"正能量有声书"];
    [self.SelectList setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
    self.SelectList.backgroundColor = [UIColor cellColor];
    //设置滑条的颜色
    self.SelectList.selectionIndicatorColor = [UIColor fontColor];
    self.SelectList.bottomTrimColor = [UIColor blueColor];
    [self.SelectList setTitleColor:[UIColor fontColor] forState:UIControlStateSelected];
    [self.SelectList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.SelectList];
}
- (IBAction)modalPlayerView:(UIBarButtonItem *)sender {
    PlayViewController *playerVC = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    playerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark - HTHorizontalSelectionListDataSource -
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList
{
    return self.ListArray.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index
{
    return self.ListArray[index];
}

#pragma mark - HTHorizontalSelectionListDelegate -
//绑定selectionList与scrollView的偏移量
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index
{
    [self.ScrollView setContentOffset:CGPointMake(kScreenW * index, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate - 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //将scrollView偏移量赋值给selecList
    self.SelectList.selectedButtonIndex = scrollView.contentOffset.x/kScreenW;
    
    [self.SelectList reloadData];
    //拖动界面时调用， 并将scrollView传过去， 用以判断偏移量
    [self scrollViewContentOffset:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //点击选测按钮时调用
    [self scrollViewContentOffset:scrollView];
}

#pragma mark - 根据不同偏移量展示不同的界面
//根据传进来的scrollView， 来判断scrollView的偏移量
- (void)scrollViewContentOffset:(UIScrollView *)scrollView
{
    NSInteger count = scrollView.contentOffset.x/kScreenW;
    //保证不让第一个推荐界面收到影响
    if (count) {
        //获取当前偏移量的视图所对应的类别名称
        NSString *title = self.ListArray[count];
        LangManYanQingViewController *langManVC = [[LangManYanQingViewController alloc] initWithStyle:UITableViewStylePlain];
        langManVC.typeStr = title;
        //标记有声书在主页面按位上的位置为0
        langManVC.typeNumber = 0;
        langManVC.tableView.frame = CGRectMake(kScreenW * count, 0, kScreenW, kScreenH - 64);
        [self.ScrollView addSubview:langManVC.tableView];
        [self addChildViewController:langManVC];
    }
}

//布局scrollView
- (void)layoutScrollView
{
    self.ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH)];
    //设置容量
    self.ScrollView.contentSize = CGSizeMake(kScreenW * self.ListArray.count, kScreenH - 64);
    //隐藏滚动条
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    //支持整页滑动
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.delegate = self;
    
    
// ****************添加推荐界面
    ShuTuiJianViewController *shuTuiJianVC = [[ShuTuiJianViewController alloc] initWithStyle:UITableViewStyleGrouped];
    shuTuiJianVC.typeNumber = 0;
    shuTuiJianVC.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-64);

    [self.ScrollView addSubview:shuTuiJianVC.tableView];
    
    //将SubView对应的ViewController也加到当前控制器的管理中
    [self addChildViewController:shuTuiJianVC];
    [self.view addSubview:self.ScrollView];
}

//内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回主页
- (IBAction)BakeHome:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
