//
//  ZhuanJiXiangQingViewController.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//
#define kScreenW self.view.frame.size.width
#define kScreenH self.view.frame.size.height
#define kZhuanJiUrl @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/1/20"

#import "ZhuanJiXiangQingViewController.h"
#import "UIColor+BackgroundColor.h"
#import "ZhuanJiHeaderView.h"
#import "AFNetworking.h"
#import "ZhuanJiHeaderModel.h"
#import "UIImageView+WebCache.h"
#import "ZhuanJiModel.h"
#import "ZhuanJiXiangQingTableViewCell.h"
#import "PlayViewController.h"
#import "MJRefresh.h"
#import "Reachability.h"

@interface ZhuanJiXiangQingViewController ()
@property (nonatomic, assign) BOOL isShouCang;
@property (nonatomic, assign) BOOL isTuiJian;
@property (nonatomic, strong) ZhuanJiHeaderModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
//用于计算分页加载
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger maxPageCount;
@end

@implementation ZhuanJiXiangQingViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置自身tableView
    [self setTablevew];
    
    //请求网络
    [self requestData];
    
    //上拉加载
    [self loadMore];
    
    //添加左划手势
    [self addGestureRecognizer];
}

- (void)setTablevew
{
    self.tableView.backgroundColor = [UIColor backgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //给isShouCang赋初值
    self.isShouCang = NO;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"正在播放" style:UIBarButtonItemStylePlain target:self action:@selector(bofang:)];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)bofang:(UIBarButtonItem *)item
{
    
    PlayViewController *playVC = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];

    playVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:playVC animated:YES completion:nil];
}

- (void)panDuan
{
    self.count++;
        if (self.count > self.maxPageCount) {
            [self.tableView.footer noticeNoMoreData];
            //提示全部加载
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已经全部加载" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            [self.tableView.footer noticeNoMoreData];
        }else
        {
            [self requestData];
        }
}

- (void)requestData
{
    if (self.count == 0) {
        self.count = 1;
    }
    NSString *ZhuanJiUrl = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/%ld/20?position=1&albumId=%@&isAsc=true", self.ID, self.count, self.ID] ;
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger GET:ZhuanJiUrl parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        [self parserData:responseObject];
    } failure:^(AFHTTPRequestOperation *  operation, NSError * error) {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
        
        //AlertView上添加Button以及点击事件
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [AlertController addAction:alertAction];
        [self presentViewController:AlertController animated:YES completion:nil];
    }];
}

- (void)loadMore
{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(panDuan)];
}

- (void)parserData:(NSData *)data
{
    //获取的整个界面的总数据
   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    //得到页眉视图的数据
    NSDictionary *headerViewDic = dic[@"album"];
    self.model = [[ZhuanJiHeaderModel alloc] initWithDictionary:headerViewDic];
    
    //得到tableView的数据
    NSArray *arr = dic[@"tracks"][@"list"];
    self.maxPageCount = [dic[@"tracks"][@"maxPageId"] integerValue];
    for (NSDictionary *dic in arr) {
        ZhuanJiModel *model = [[ZhuanJiModel alloc] initWithDic:dic];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
    //在请求数据成功后， 添加tableView页眉视图
    [self addHeaderView];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZhuanJiXiangQingTableViewCell *cell = [ZhuanJiXiangQingTableViewCell cellWithTableView:tableView];
    ZhuanJiModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.backgroundColor = [UIColor cellColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //检测是否是在wifi状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (!(reach.currentReachabilityStatus == ReachableViaWiFi)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为非WiFi连接状态，是否继续播放？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PlayViewController *playVC= [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
            playVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            playVC.dataSource = self.dataSource;
            playVC.indexNum = indexPath.row;
            playVC.model = self.dataSource[indexPath.row];
            
            [self presentViewController:playVC animated:YES completion:nil];
            
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        PlayViewController *playVC= [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        playVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        playVC.dataSource = self.dataSource;
        playVC.indexNum = indexPath.row;
        playVC.model = self.dataSource[indexPath.row];
        
        [self presentViewController:playVC animated:YES completion:nil];
    }
}

#pragma  mark - 添加页眉视图
- (void)addHeaderView
{
    //创建底层的image
    UIImageView *diCengImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    [diCengImage sd_setImageWithURL:[NSURL URLWithString:self.model.coverMiddle] placeholderImage:[UIImage imageNamed:@"m.jpg"]];
    diCengImage.contentMode =  UIViewContentModeScaleAspectFit;
    diCengImage.userInteractionEnabled = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, kScreenW, 200);
    [diCengImage addSubview:effectView];
    
    
    //创建页眉视图
    ZhuanJiHeaderView *headerView = [[ZhuanJiHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    //给页眉视图赋值
    headerView.model = self.model;
    
    [effectView.contentView addSubview:headerView];
    
    self.tableView.tableHeaderView = diCengImage;
}

#pragma mark - 设置组页眉视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //左边的Label
    UILabel *jiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2.0, 0, kScreenW/2.0, 40)];
    jiLabel.text = [NSString stringWithFormat:@"共%ld集", self.model.tracks];
    jiLabel.textAlignment = NSTextAlignmentCenter;
    jiLabel.textColor = [UIColor lightGrayColor];
    jiLabel.backgroundColor = [UIColor backgroundColor];
    jiLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    jiLabel.layer.borderWidth = 0.3;
    jiLabel.layer.masksToBounds = YES;
    
    //中间的Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW/2.0, 40)];
    if (self.typeStr) {
        titleLabel.text = [NSString stringWithFormat:@"%@", self.typeStr];
    }else
    {
        titleLabel.text = @"推荐";
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.backgroundColor = [UIColor backgroundColor];
    titleLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    titleLabel.layer.borderWidth = 0.3;
    titleLabel.layer.masksToBounds = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [view addSubview:jiLabel];
    [view addSubview:titleLabel];
//    [view addSubview:TuiJianButton];
    
    return view;
}

#pragma mark - 设置组页眉高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"必须要实现这个方法， 才能在分组页眉上添加视图";
}

#pragma mark - 添加左划手势
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipe];
}

- (void)swipAction:(UISwipeGestureRecognizer *)swipe
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
