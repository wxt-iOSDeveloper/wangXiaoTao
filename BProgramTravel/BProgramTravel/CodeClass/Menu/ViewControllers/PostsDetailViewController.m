//
//  PostsDetailViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PostsDetailViewController.h"
#import "PostsDetailHeaderView.h"
#import "TrendsDetailTableViewCell.h"
#import "TrendsDetailModel.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfoViewController.h"
@interface PostsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PostsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell自适应高度
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TrendsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"postsDetailCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"firstCell"];
    [self.view addSubview:self.tableView];
    //创建头部视图
    [self createTabelViewHeaderView];
    //请求评论数据
    [self requestData];
}
//创建头部视图
- (void)createTabelViewHeaderView {
    //根据传过来的model中的图片和content计算头部视图的高度
    CGFloat contentH = [[NetworkingManager sharedNetWorkingMangaer] contentLabelHeightWithContent:[self.passModel.feed objectForKey:@"content"]];
    CGFloat pictureViewH = 0;
    if (self.passModel.pictureList.count == 0) {
        pictureViewH = 0;
    } else {
        pictureViewH = 80;
    }
    PostsDetailHeaderView *postHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"PostsDetailHeaderView" owner:nil options:nil] firstObject];//获取相应的xib
    postHeaderView.frame = CGRectMake(0, 0, kDeviceWidth, contentH + pictureViewH + 121);
    
    [postHeaderView setValueFromModel:self.passModel];
    
    //创建contentLabel和imageView放在view上
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, kDeviceWidth - 10 - 20, contentH)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = [self.passModel.feed objectForKey:@"content"];
    contentLabel.font = [UIFont boldSystemFontOfSize:15];
    [postHeaderView addSubview:contentLabel];
    if (pictureViewH != 0) {
        for (int i = 0; i < self.passModel.pictureList.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * 85, 110 + contentH, 80, 80)];
            NSString *picStr = [[self.passModel.pictureList objectAtIndex:i] objectForKey:@"url"];
            [imageView setImageWithURL:[NSURL URLWithString:[kImageURL stringByAppendingString:picStr]]];
            [postHeaderView addSubview:imageView];
        }
    }
    self.tableView.tableHeaderView = postHeaderView;
}
//请求数据
- (void)requestData {
    [NetworkingManager requestPOSTWithUrlString:kRequestCommentURL parDic:@{@"sToken":ksToken,@"feedId":[self.passModel.feed objectForKey:@"feedId"]} finish:^(id responseObject) {
        NSLog(@"******%@", responseObject);
        //解析数据
        NSArray *tempArray = [responseObject objectForKey:@"customerReplyList"];
        //如果没有评论 就跳过遍历封装
        if (![tempArray isEqual:[NSNull null]]) {
            for (NSDictionary *dic in tempArray) {
                TrendsDetailModel *model = [[TrendsDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        //数据请求完之后 数组为空 就关闭分割线
        if (self.dataArray.count == 0) {
            self.tableView.separatorStyle = NO;
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    if (self.dataArray.count == 0) {
        firstCell.textLabel.text = @"暂无评论";
        firstCell.textLabel.textAlignment = NSTextAlignmentCenter;
        return firstCell;
    }
    if (indexPath.row == 0) {
        NSString *str = @"评论 ";
        firstCell.textLabel.text = [str stringByAppendingString:[NSString stringWithFormat:@"%ld",self.dataArray.count]];
        firstCell.textLabel.textAlignment = NSTextAlignmentLeft;
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中时的灰色阴影
        return firstCell;
    }
    if (self.dataArray.count == 0) {
        return nil;
    }
    TrendsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postsDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TrendsDetailModel *model = [self.dataArray objectAtIndex:indexPath.row - 1];
    [cell setValueWithModel:model];
    cell.tapActionBlock = ^void (void) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.passNameString = [model.userBasic objectForKey:@"name"];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    };
    return cell;
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
