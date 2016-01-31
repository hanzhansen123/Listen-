//
//  TopTableViewController.m
//  Listen
//
//  Created by laouhn on 15/11/17.
//  Copyright © 2015年 HanZhanSen. All rights reserved.
//

#define kYouShengShuTopUrl @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=android&key=ranking%3Aalbum%3Aplayed%3A1%3A3&pageId=1&pageSize=40&title=%E6%9C%89%E5%A3%B0%E4%B9%A6top50"
#define kYinYueTopUrl @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=android&key=ranking%3Aalbum%3Aplayed%3A1%3A2&pageId=1&pageSize=40&title=%E9%9F%B3%E4%B9%90%E6%A6%9CTOP50"
#define kXiangShengUrl @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=android&key=ranking%3Aalbum%3Aplayed%3A7%3A12&pageId=1&pageSize=40&title=%E7%9B%B8%E5%A3%B0%E8%AF%84%E4%B9%A6%E6%8E%92%E8%A1%8C%E6%A6%9C"
#define kBaiJiaJiangTan @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=android&key=ranking%3Aalbum%3Aplayed%3A7%3A14&pageId=1&pageSize=40&title=%E7%99%BE%E5%AE%B6%E8%AE%B2%E5%9D%9B%E6%8E%92%E8%A1%8C%E6%A6%9C"
#define kGuangBoJu @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album?device=android&key=ranking%3Aalbum%3Aplayed%3A7%3A15&pageId=1&pageSize=40&title=%E5%B9%BF%E6%92%AD%E5%89%A7%E6%8E%92%E8%A1%8C%E6%A6%9C"

#import "TopTableViewController.h"
#import "UIColor+BackgroundColor.h"
#import <AFNetworking.h>
#import "TopModel.h"
#import "TopTableViewCell.h"
#import "ZhuanJiXiangQingViewController.h"
#import "PlayViewController.h"

@interface TopTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TopTableViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView
    [self setTableView];
    
    //请求数据
    [self requestData];
    
}

- (void)JinRuBoFang:(UIBarButtonItem *)item
{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PlayViewController *playView = [storyBoard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    PlayViewController *playView = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    
    playView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:playView animated:YES completion:nil];
}

- (void)setTableView
{
    //添加导航栏右侧item
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithTitle:@"正在播放" style:UIBarButtonItemStylePlain target:self action:@selector(JinRuBoFang:)];
    self.navigationItem.rightBarButtonItem = playItem;
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.separatorColor = [UIColor blueColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    switch (self.typeNumber) {
        case 0:
            self.title = @"有声书Top50";
            break;
        case 1:
            self.title = @"音乐榜Top50";
            break;
        case 2:
            self.title = @"相声评书排行榜";
            break;
        case 3:
            self.title = @"百家讲坛排行榜";
            break;
        case 4:
            self.title = @"广播剧排行榜";
            break;
        default:
            break;
    }
}

- (void)requestData
{
    NSString *url = @"";
    switch (self.typeNumber) {
        case 0:
            url = kYouShengShuTopUrl;
            break;
        case 1:
            url = kYinYueTopUrl;
            break;
        case 2:
            url = kXiangShengUrl;
            break;
        case 3:
            url = kBaiJiaJiangTan;
            break;
        case 4:
            url = kGuangBoJu;
            break;
        default:
            break;
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        [self parserData:responseObject];
    } failure:^(AFHTTPRequestOperation *  operation, NSError *  error) {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接失败，请检查网络！" preferredStyle:UIAlertControllerStyleAlert];
        
        //AlertView上添加Button以及点击事件
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [AlertController addAction:alertAction];
        [self presentViewController:AlertController animated:YES completion:nil];
    }];
}

- (void)parserData:(NSDictionary *)dic
{
    NSArray *array = dic[@"list"];
    for (NSDictionary *dict in array) {
        TopModel *model = [[TopModel alloc] initWithDic:dict];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopModel *model = self.dataSource[indexPath.row];
    TopTableViewCell *cell = [TopTableViewCell cellWithTableView:tableView];
    cell.model = model;
    cell.Number.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    
    cell.backgroundColor = [UIColor cellColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZhuanJiXiangQingViewController *zhuanJiVC = [[ZhuanJiXiangQingViewController alloc] initWithStyle:UITableViewStylePlain];
    TopModel *model = self.dataSource[indexPath.row];
    zhuanJiVC.ID = model.ID;
    [self.navigationController pushViewController:zhuanJiVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
