//
//  PostsViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PostsViewController.h"
#import "PostsTableViewCell.h"
#import "PostsModel.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfoViewController.h"
#import "PostsDetailViewController.h"
#import "MJRefresh.h"

@interface PostsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
BOOL postsIsDown = YES;
int postsPage = 1;

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.navigationItem.title = self.titleString;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PostsTableViewCell" bundle:nil] forCellReuseIdentifier:@"postsCell"];
    //cell自适应高度
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    //请求数据
    [self showProgressHUDWithString:@"玩命加载中..."];
    [self requestData];
    [self.tableView addHeaderWithTarget:self action:@selector(postsDownAction)];
    [self.tableView addFooterWithTarget:self action:@selector(postsUpAction)];
    //导航条上返回按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"66.png"] style:UIBarButtonItemStyleDone target:self action:@selector(handleLeftBarButtonAction:)];
    //给左边添加item
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
//下拉刷新
- (void)postsDownAction {
    postsIsDown = YES;
    postsPage = 1;
    [self requestData];
}
- (void)postsUpAction {
    postsIsDown = NO;
    postsPage += 1;
    [self requestData];
}
//返回上一界面
- (void)handleLeftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



//请求数据
- (void)requestData {
    NSString *pageStr = [NSString stringWithFormat:@"%d", postsPage];
    if (self.customerUserId == nil) {
        NSString *terminiId = nil;
        NSString *isChinese = nil;
        if (self.passSearchModel == nil) {
            //从约伴界面进来的
            isChinese = [self.passParnterModel.isChina stringValue];
            if ([isChinese isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
                terminiId = [self.passParnterModel.provinceInfo objectForKey:@"id"];
            } else {
                terminiId = [self.passParnterModel.nationInfo objectForKey:@"id"];
            }
        } else {
            //从搜索界面进来
            isChinese = [self.passSearchModel.isChina stringValue] ;
            if ([isChinese isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
                terminiId = [self.passSearchModel.provinceInfo objectForKey:@"id"];
            } else {
                terminiId = [self.passSearchModel.nationInfo objectForKey:@"id"];
            }
        }
        [NetworkingManager requestPOSTWithUrlString:kPostsURL parDic:@{@"sToken":ksToken,@"terminiId":terminiId,@"isChinese":isChinese,@"page":pageStr} finish:^(id responseObject) {
            //解析数据
            [self praserDataWithResponse:responseObject];
        } error:^(NSError *error) {
            
        }];
    }else {
        [NetworkingManager requestPOSTWithUrlString:kAllPartnerURL parDic:@{@"sToken":ksToken,@"userId":self.customerUserId,@"customerUserId":kUserId,@"page":pageStr} finish:^(id responseObject) {
            //解析数据
            [self praserDataWithResponse:responseObject];
        } error:^(NSError *error) {
            
        }];
    }
    
}
//解析数据
- (void)praserDataWithResponse:(id)responseObject {
    if (postsIsDown == YES) {
      [self.dataArray removeAllObjects];
    }
    NSArray *array = [responseObject objectForKey:@"customerFeedList"];
    if ([array isEqual:[NSNull null]]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, kDeviceWidth - 140, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂时没有约伴帖子";
        [self.tableView addSubview:label];
        return;
    }
    for (NSDictionary *dic in array) {
        PostsModel *model = [[PostsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];;
        [self.dataArray addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PostsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setvaluesForCellWithModel:model];
    //实现block
    cell.tapActionBlock = ^void (PostsModel *passModel) {
      //跳转页面
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.passNameString = [passModel.author objectForKey:@"name"];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    };
    return cell;
}


//点击cell 跳转至详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostsDetailViewController *postsDetail = [[PostsDetailViewController alloc] init];
    PostsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    postsDetail.passModel = model;
    [self.navigationController pushViewController:postsDetail animated:YES];
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
