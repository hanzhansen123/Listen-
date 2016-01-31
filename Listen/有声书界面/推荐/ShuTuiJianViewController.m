//
//  ShuTuiJianViewController.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//
#define kShuTuiJianURL @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=3&contentType=album&device=android&scale=2&version=4.3.26.2"
#define kYinYueURL @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=2&contentType=album&device=android&scale=2&version=4.3.26.2"
#define kXiangShengURl @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=12&contentType=album&device=android&scale=2&version=4.3.26.2"
#define kBaiJiaJiangTan @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=14&contentType=album&device=android&scale=2&version=4.3.26.2"
#define kGuangBoJu @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=15&contentType=album&device=android&scale=2&version=4.3.26.2"

#define kScreenW self.view.frame.size.width
#define kScreenH self.view.frame.size.height

#import "ShuTuiJianViewController.h"
#import "UIColor+BackgroundColor.h"
#import "AFNetworking.h"
#import "MCell.h"
#import "ShuTuiJianModel.h"
#import "PaiHangBangModel.h"
#import "PaiHangCell.h"
#import "TopTableViewController.h"
#import "ZhuanJiXiangQingViewController.h"
#import "ShuTuiJianLunBoCell.h"
#import "ShuTuiJianLunBoModel.h"
#import "ZhuanJiModel.h"
#import "PlayViewController.h"
#import "MJRefresh.h"
#import "Reachability.h"

@interface ShuTuiJianViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) NSMutableArray *LunBoDataSouce;
@property (nonatomic, strong) UICollectionView *LunBoView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageContol;
@property (nonatomic, assign) ShuTuiJianLunBoModel *model;//点击轮播图上的那张图片的Model

@property (nonatomic, strong) NSMutableArray *zuiHuoModelArr;
@property (nonatomic, strong) NSMutableArray *yiBanModelArr;
@end

@implementation ShuTuiJianViewController

- (NSMutableArray *)dataSouce
{
    if (!_dataSouce) {
        self.dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}

- (NSMutableArray *)LunBoDataSouce
{
    if (!_LunBoDataSouce) {
        self.LunBoDataSouce = [NSMutableArray array];
    }
    return _LunBoDataSouce;
}

- (NSMutableArray *)zuiHuoModelArr
{
    if (!_zuiHuoModelArr) {
        self.zuiHuoModelArr = [NSMutableArray array];
    }
    return _zuiHuoModelArr;
}

- (NSMutableArray *)yiBanModelArr
{
    if (!_yiBanModelArr) {
        self.yiBanModelArr = [NSMutableArray array];
    }
    return _yiBanModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //设置tableView自身属性
    [self setTableview];
    
    //设置页眉轮播图
    [self setHeaderView];
    
    //进入界面加载数据
    [self setRefresh];
}

- (void)setRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    //进入界面自动开始刷新界面
    [self.tableView.header beginRefreshing];
}

- (void)setTableview
{
     self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor blueColor];
    //设置导航栏颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
}

#pragma mark - 设置轮播图
- (void)setHeaderView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenW, 200);
    //设置缩进值
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置每个item之间的距离
    layout.minimumLineSpacing = 0;
    //设置滑动方向为水平滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.LunBoView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 200) collectionViewLayout:layout];
    self.LunBoView.backgroundColor = [UIColor backgroundColor];
    self.LunBoView.showsHorizontalScrollIndicator = NO;
    self.LunBoView.pagingEnabled = YES;
    
    self.LunBoView.delegate = self;
    self.LunBoView.dataSource = self;
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"ShuTuiJianLunBoCell" bundle:nil];
    [self.LunBoView registerNib:nib forCellWithReuseIdentifier:@"ShuTuiJianLunBoCell"];
    
    //把轮播视图设置为tableView的页眉视图
    self.tableView.tableHeaderView = self.LunBoView;
}

#pragma mark - 添加定时器
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.LunBoView.contentOffset = CGPointMake(600*kScreenW, 0);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TimeAction:) userInfo:nil repeats:YES];
}

- (void)TimeAction:(NSTimer *)timer
{
    CGFloat x = self.LunBoView.contentOffset.x + kScreenW;
    [self.LunBoView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

//当拖拽轮播图时移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

//当结束拖拽轮播图时添加定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TimeAction:) userInfo:nil repeats:YES];
}

//获取当前collectionView所展示的那个item
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [[self.LunBoView indexPathsForVisibleItems] firstObject];
    self.pageContol.currentPage = visiablePath.item % self.LunBoDataSouce.count;
    
    //获得当前所展示item的Model
    self.model = self.LunBoDataSouce[visiablePath.item % self.LunBoDataSouce.count];
    
    //给cell添加轻拍点击方法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [cell addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    //self.tapID即为点击图片的ID
    if (self.model.type == 2) {
        //进入专辑界面
        ZhuanJiXiangQingViewController *zhuanjiVC = [[ZhuanJiXiangQingViewController alloc] initWithStyle:UITableViewStylePlain];
        zhuanjiVC.ID = [NSString stringWithFormat:@"%ld", (long)self.model.albumId];
        [self.navigationController pushViewController:zhuanjiVC animated:YES];
    }
    if (self.model.type == 3) {
        NSString *type3Url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/track/%ld?device=android", (long)self.model.trackId];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manger GET:type3Url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
            
            [self jieXiData:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
            
            UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
            
            //AlertView上添加Button以及点击事件
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [AlertController addAction:alertAction];
            [self presentViewController:AlertController animated:YES completion:nil];
        }];
    }
}

- (void)jieXiData:(NSData *)data
{
    //判断是否是在WiFi状态连接
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if (!(reach.currentReachabilityStatus == ReachableViaWiFi)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为非WiFi连接状态，是否继续播放？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            ZhuanJiModel *model = [[ZhuanJiModel alloc] initWithDic:dic];
            PlayViewController *player = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
            player.model = model;
            player.dataSource = @[model];
            player.indexNum = 0;
            
            player.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:player animated:YES completion:nil];
            
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        ZhuanJiModel *model = [[ZhuanJiModel alloc] initWithDic:dic];
        PlayViewController *player = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        player.model = model;
        player.dataSource = @[model];
        player.indexNum = 0;
        
        player.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:player animated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDataSource -
//设置每组的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.LunBoDataSouce.count * 10000;
}

//设置组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShuTuiJianLunBoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShuTuiJianLunBoCell" forIndexPath:indexPath];
    
    ShuTuiJianLunBoModel *model = self.LunBoDataSouce[indexPath.item % self.LunBoDataSouce.count];
    
    cell.model = model;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //在这里显示计算偏移量
}

#pragma mark - 请求对应界面的数据
- (void)requestData
{
    NSString *url = @"";
    switch (self.typeNumber) {
        case 0:
        {
            url = kShuTuiJianURL;
        }
            break;
        case 1:
        {
           url = kYinYueURL;
        }
            break;
        case 2:
        {
            url = kXiangShengURl;
        }
            break;
        case 3:
        {
            url = kBaiJiaJiangTan;
        }
            break;
        case 4:
        {
            url = kGuangBoJu;
        }
            break;
            
        default:
            break;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id  responseObject) {
        [self parserData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
        
        //AlertView上添加Button以及点击事件
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [AlertController addAction:alertAction];
        [self presentViewController:AlertController animated:YES completion:nil];
        
        //停止刷新控件
        [self.tableView.header endRefreshing];
    }];
}

- (void)parserData:(NSDictionary *)dic
{
    //清空原有数组
    [self.dataSouce removeAllObjects];
    [self.zuiHuoModelArr removeAllObjects];
    [self.yiBanModelArr removeAllObjects];
    NSArray *array = dic[@"categoryContents"][@"list"];
    for (NSDictionary *dic in array) {
        [self.dataSouce addObject:dic];
        NSInteger type = [[dic valueForKey:@"moduleType"] integerValue];
        if (type == 2) {
            
        }
        if (type == 3) {
            NSArray *arr = dic[@"list"];
            for (NSDictionary *dict in arr) {
                ShuTuiJianModel *model = [[ShuTuiJianModel alloc] initWithDic:dict];
                [self.zuiHuoModelArr addObject:model];
            }
        }
        if (type == 5){
            NSArray *arr = dic[@"list"];
            for (NSDictionary *dict in arr) {
                ShuTuiJianModel *model = [[ShuTuiJianModel alloc] initWithDic:dict];
                [self.yiBanModelArr addObject:model];
            }
        }
    }
    
    //清空原有数组
    [self.LunBoDataSouce removeAllObjects];
    NSArray *lunBoArr = dic[@"focusImages"][@"list"];
    for (NSDictionary *dic in lunBoArr) {
        ShuTuiJianLunBoModel *model = [[ShuTuiJianLunBoModel alloc] initWithDic:dic];
        [self.LunBoDataSouce addObject:model];
    }
    [self.LunBoView reloadData];
    [self.tableView reloadData];
    //停止刷新控件
    [self.tableView.header endRefreshing];
    
    //在请求到数据后添加轮播图的pagecontrol
    //轮播图可以提前添加是因为轮播图可以在请求完数据后刷新表格
    //设置pageControl
    self.pageContol = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenW - 150, self.tableView.tableHeaderView.frame.size.height - 50, 160, 37)];
    self.pageContol.numberOfPages = self.LunBoDataSouce.count;
    self.pageContol.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageContol.pageIndicatorTintColor = [UIColor grayColor];
    [self.tableView addSubview:self.pageContol];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSouce.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataSouce[section][@"list"] count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataSouce[indexPath.section];
    
    NSInteger type = [[dictionary valueForKey:@"moduleType"] integerValue];
    
    if (type == 2) {
        PaiHangCell *cell = [PaiHangCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor cellColor];
        return cell;
    }
    if (type == 3) {
        MCell *cell = [MCell cellWithTable:tableView];
        cell.model = self.zuiHuoModelArr[indexPath.row];
        
        cell.backgroundColor = [UIColor cellColor];
         return cell;
    }else if (type == 5)
    {
        MCell *cell = [MCell cellWithTable:tableView];
        cell.model = self.yiBanModelArr[indexPath.row + (indexPath.section - 2) * 3];
        cell.backgroundColor = [UIColor cellColor];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    view.backgroundColor = [UIColor cellColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    NSString *str = self.dataSouce[section][@"title"];
    lable.text = str;
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor colorWithRed:158/255.0 green:153/255.0 blue:1 alpha:1.0];
    [view addSubview:lable];
    return view;
}

//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else
    {
        return 80;
    }
}

//设置分组页眉高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

//设置分组页脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TopTableViewController *topVC = [[TopTableViewController alloc] initWithStyle:UITableViewStylePlain];
        topVC.typeNumber = self.typeNumber;
        [self.navigationController pushViewController:topVC animated:YES];
    }else{
        ZhuanJiXiangQingViewController *zhuanjiVC = [[ZhuanJiXiangQingViewController alloc] initWithStyle:UITableViewStylePlain];
        
        if (indexPath.section == 1) {
            ShuTuiJianModel *model = self.zuiHuoModelArr[indexPath.row];
            zhuanjiVC.ID = model.ID;
        }else
        {
            ShuTuiJianModel *model = self.yiBanModelArr[indexPath.row + (indexPath.section - 2) * 3];
            zhuanjiVC.ID = model.ID;
        }
        
        [self.navigationController pushViewController:zhuanjiVC animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
