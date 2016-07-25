//
//  FansAndFoucsViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/20.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "FansAndFoucsViewController.h"
#import "FansAndFouceModel.h"
#import "FansAndFouceTableViewCell.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
@interface FansAndFoucsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FansAndFoucsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"FansAndFouceTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    //请求数据
    [self requestData];
    
}

- (void)requestData {
    NSString *strURL = nil;
    if (self.isFans == YES) {
        strURL = kAllFansURL;
    } else {
        strURL = kAllFocusURL;
    }
    [NetworkingManager requestPOSTWithUrlString:strURL parDic:@{@"sToken":ksToken,@"sourceUserId":kUserId,@"targetUserId":self.targetUserId} finish:^(id responseObject) {
        NSLog(@"******%@",responseObject);
        NSArray *array = [responseObject objectForKey:@"customerUserList"];
        if ([array isEqual:[NSNull null]]) {
            //没有关注的用户或者粉丝
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, (kDeviceHeight - 64 - 49 - 40) / 2, kDeviceWidth - 140, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂时没有关注用户";
            [self.tableView addSubview:label];
            return;
        }
        for (NSDictionary *dic in array) {
            FansAndFouceModel *model = [[FansAndFouceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansAndFouceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FansAndFouceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValueWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

//点击cell 回到用户信息界面 展示当前cell的用户的信息
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FansAndFouceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.isEnterByMy == YES) {
        //通过我的界面进入的列表
        UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
        userVC.passNameString = [model.userBasic objectForKey:@"name"];
        userVC.fansPassModel = model;
        [self.navigationController pushViewController:userVC animated:YES];
    } else {
        //通过用户信息界面 进入的列表
        self.controller.passNameString = [model.userBasic objectForKey:@"name"];
        self.controller.isClickCell = YES;
        self.controller.fansPassModel = model;
        [self.navigationController popViewControllerAnimated:YES];
    }
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
