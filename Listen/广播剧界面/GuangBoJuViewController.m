//
//  GuangBoJuViewController.m
//  Listen
//
//  Created by laouhn on 15/11/24.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//
#define kScreenW self.view.frame.size.width
#define kScreenH self.view.frame.size.height

#import "GuangBoJuViewController.h"
#import "HTHorizontalSelectionList.h"
#import "UIColor+BackgroundColor.h"
#import "ShuTuiJianViewController.h"
#import "PlayViewController.h"
#import "LangManYanQingViewController.h"

@interface GuangBoJuViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) HTHorizontalSelectionList *SelectList;
@property (nonatomic, strong) NSArray *ListArray;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@end

@implementation GuangBoJuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //布局选择列表视图
    [self layoutSelectionListView];
    //布局scrollView
    [self layoutScrollView];
}

- (void)layoutSelectionListView
{
    self.SelectList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 40)];
    self.SelectList.delegate = self;
    self.SelectList.dataSource = self;
    self.ListArray = @[@"推荐", @"古风剧",@"现代剧", @"全年龄",  @"剧情歌", @"耽美剧", @"百合剧", @"二次元", @"CV剧", @"FT等"];
    [self.SelectList setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
    self.SelectList.backgroundColor = [UIColor cellColor];
    //设置滑条的颜色
    self.SelectList.selectionIndicatorColor = [UIColor fontColor];
    self.SelectList.bottomTrimColor = [UIColor blueColor];
    [self.SelectList setTitleColor:[UIColor fontColor] forState:UIControlStateSelected];
    [self.SelectList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.SelectList];
}

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
    shuTuiJianVC.typeNumber = 4;
    shuTuiJianVC.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-64);
    
    [self.ScrollView addSubview:shuTuiJianVC.tableView];
    
    //将SubView对应的ViewController也加到当前控制器的管理中
    [self addChildViewController:shuTuiJianVC];
    [self.view addSubview:self.ScrollView];
}


- (IBAction)HomeView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PlayerView:(UIBarButtonItem *)sender {
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
        //将标题传到下个界面， 因为下个界面的URL内部需要作为参数
        langManVC.typeStr = title;
        //标记有声书在主页面按位上的位置为0
        langManVC.typeNumber = 4;
        langManVC.tableView.frame = CGRectMake(kScreenW * count, 0, kScreenW, kScreenH - 64);
        [self.ScrollView addSubview:langManVC.tableView];
        [self addChildViewController:langManVC];
    }
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
