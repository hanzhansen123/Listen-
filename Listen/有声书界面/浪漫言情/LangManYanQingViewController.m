//
//  LangManYanQingViewController.m
//  Listen
//
//  Created by laouhn on 15/11/19.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//
#define kScreenW self.view.frame.size.width
#define kScreenH self.view.frame.size.height

#import "LangManYanQingViewController.h"
#import "AFNetworking.h"
#import "ShuTuiJianModel.h"
#import "MCell.h"
#import "UIColor+BackgroundColor.h"
#import "ZhuanJiXiangQingViewController.h"
#import "MJRefresh.h"

@interface LangManYanQingViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger page;
@end

@implementation LangManYanQingViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor backgroundColor];
    //如果数据不够显示一个界面， 就将多余的cell取消
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    
    [self setHeader];
    
    //上拉加载
    [self setFooter];
}

- (void)setHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //自定进入刷新状态
    [self.tableView.header beginRefreshing];
}

- (void)setFooter
{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMore)];
}

- (void)loadData
{
    NSString *url = @"";
    switch (self.typeNumber) {
        case 0:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=3&device=android&pageId=1&pageSize=20&status=0&tagName=%@", self.typeStr];
            break;
        case 1:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=android&pageId=1&pageSize=20&status=0&tagName=%@", self.typeStr];
            break;
        case 2:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=12&device=android&pageId=1&pageSize=20&status=0&tagName=%@", self.typeStr];
            break;
        case 3:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=14&device=android&pageId=1&pageSize=20&status=0&tagName=%@", self.typeStr];
            break;
             case 4:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=15&device=android&pageId=1&pageSize=20&status=0&tagName=%@", self.typeStr];
            break;
        default:
            break;
    }
//    NSString *newUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, nil, nil, kCFStringEncodingUTF8));
#warning 这里修改过编码格式
    NSString *newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:newUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self parserData:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //加载失败时弹出提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self.tableView.header endRefreshing];
    }];
}

- (void)LoadMore
{
    NSString *url = @"";
    if (!self.page) {
        self.page = 1;
    }
    self.page++;
    switch (self.typeNumber) {
        case 0:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=3&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", (long)self.page, self.typeStr];
            break;
        case 1:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=2&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", (long)self.page, self.typeStr];
            break;
        case 2:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=12&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", (long)self.page, self.typeStr];
            break;
        case 3:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=14&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", (long)self.page, self.typeStr];
            break;
        case 4:
            url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=15&device=android&pageId=%ld&pageSize=20&status=0&tagName=%@", (long)self.page, self.typeStr];
            break;
        default:
            break;
    }
    if (self.page >= 5) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已经全部加载" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.tableView.footer noticeNoMoreData];
    }else
    {
#warning 这里修改过编码格式
//        NSString *newUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, nil, nil, kCFStringEncodingUTF8));
        NSString *newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        [manger GET:newUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [self parserData:responseObject];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            //加载失败时弹出提示框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [self.tableView.footer endRefreshing];
        }];
    }
}

- (void)parserData:(NSDictionary *)dic
{
    NSArray *array = dic[@"list"];
    for (NSDictionary *dic in array) {
        ShuTuiJianModel *model = [[ShuTuiJianModel alloc] initWithDic:dic];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCell *cell = [MCell cellWithTable:tableView];
    ShuTuiJianModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.backgroundColor = [UIColor cellColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhuanJiXiangQingViewController *zhuanjiVC = [[ZhuanJiXiangQingViewController alloc] initWithStyle:UITableViewStylePlain];
    ShuTuiJianModel *model = self.dataSource[indexPath.row];
    zhuanjiVC.ID = model.ID;
    zhuanjiVC.typeStr = self.typeStr;
    [self.navigationController pushViewController:zhuanjiVC animated:YES];
    
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
