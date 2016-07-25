//
//  UserInfoViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfoHeaderView.h"
#import "PersonalTrendsViewController.h"
#import "MapViewController.h"
#import "FansAndFoucsViewController.h"
#import "PostsViewController.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isClickCell == YES) {
        [self requestTableHeaderViewData];//重新请求数据
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.passModel.author objectForKey:@"name"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infoCell"];
    [self.view addSubview:self.tableView];
    //请求头部视图数据
    [self requestTableHeaderViewData];
}

//请求头部视图数据
- (void)requestTableHeaderViewData {
    NSString *str = nil;
    if (self.passNameString == nil) {
        //从动态页面点进来的
        str = [self.passModel.author objectForKey:@"name"];
    } else {
        //从热门目的地帖子列表点进来
        str = self.passNameString;
    }
    [NetworkingManager requestPOSTWithUrlString:kUserInfoURL parDic:@{@"sToken":ksToken,@"sourceUserId":kUserId,@"targetUserName":str} finish:^(id responseObject) {
        //请求成功 解析数据
        
        self.dataDic = responseObject;
        NSDictionary *bigDic = [self.dataDic objectForKey:@"CustomerUserDetail"];
        UserInfoHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView" owner:nil options:nil] firstObject];//获取UIView关联的xib
        view.frame = CGRectMake(0, 0, kDeviceWidth, 310);
        
        [view setViewWithDic:bigDic];
        view.bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view.bigImageView addGestureRecognizer:tap];
        
        [view.focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.fansNum addTarget:self action:@selector(fansNumAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.focusNum addTarget:self action:@selector(focusNumAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableHeaderView = view;
        
        [self.tableView reloadData];
        
        NSLog(@"%@", responseObject);
    } error:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

//跳转粉丝列表
- (void)fansNumAction:(UIButton *)sender {
    FansAndFoucsViewController *FAFVC = [[FansAndFoucsViewController alloc] init];
    FAFVC.isFans = YES;
    FAFVC.controller = self;
    FAFVC.targetUserId = [[[self.dataDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
    [self.navigationController pushViewController:FAFVC animated:YES];
}
//跳转关注列表
- (void)focusNumAction:(UIButton *)sender {
    FansAndFoucsViewController *FAFVC = [[FansAndFoucsViewController alloc] init];
    FAFVC.isFans = NO;
    FAFVC.controller = self;
    FAFVC.targetUserId = [[[self.dataDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
    [self.navigationController pushViewController:FAFVC animated:YES];
}



//点击关注按钮 进行关注或者取消关注
- (void)focusButtonAction:(UIButton *)sender {
    NSString *followUserId = nil;
    int relationtype = 0;
    if (self.passModel == nil) {
        //从粉丝和关注用户列表界面点击进来的
        followUserId = [self.fansPassModel.userBasic objectForKey:@"userId"];
        relationtype = [self.fansPassModel.relationType intValue];
    } else {
        followUserId = [self.passModel.author objectForKey:@"userId"];
        relationtype = [self.fansPassModel.relationType intValue];
    }
    if (relationtype == 0) {
        //没有关注 进行关注
        [NetworkingManager requestPOSTWithUrlString:kGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"followUserId":followUserId} finish:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                if (self.passModel == nil) {
                    self.fansPassModel.relationType = @1;
                } else {
                    self.passModel.relationType = @1;
                }
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        //确定后取消关注
        [NetworkingManager requestPOSTWithUrlString:kCancelGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"unfollowUserId":followUserId} finish:^(id responseObject) {
            NSLog(@"----%@", responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                //取消关注成功
                [sender setTitle:@"加关注" forState:UIControlStateNormal];
                if (self.passModel == nil) {
                    self.fansPassModel.relationType = @0;
                } else {
                    self.passModel.relationType = @0;
                }
            } else {
                NSLog(@"%@", [responseObject objectForKey:@"errorReason"]);
            }
        } error:^(NSError *error) {
            
        }];
    }

}

//点击大图片 跳转至地图
- (void)tapAction:(UITapGestureRecognizer *)sender {
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    if (self.passNameString == nil) {
        mapVC.ueserName = [self.passModel.author objectForKey:@"name"];
    } else {
        mapVC.ueserName = self.passNameString;
    }
    [self presentViewController:mapVC animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        NSNumber *feedCount = [[self.dataDic objectForKey:@"CustomerUserDetail"] objectForKey:@"feedCount"] ;
        cell.textLabel.text = [NSString stringWithFormat:@"帖子(%@)", feedCount];
    } else {
        NSNumber *partnerPostsCount = [self.dataDic objectForKey:@"InviteFeedCountOfTargetUser"];
        if ([partnerPostsCount intValue] == 0) {
            cell.textLabel.text = @"约伴";
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"约伴(%@)",partnerPostsCount];
        }
    }
    return cell;
}


//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //第一个单元格推到动态列表界面
        PersonalTrendsViewController *personalVC = [[PersonalTrendsViewController alloc] init];
        personalVC.passDic = [self.dataDic objectForKey:@"CustomerUserDetail"];
        [self.navigationController pushViewController:personalVC animated:YES];
    } else {
        //第二个推到发过的约伴列表界面
        PostsViewController *postVC = [[PostsViewController alloc] init];
        postVC.titleString = [[[self.dataDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"name"];
        postVC.customerUserId = [[[self.dataDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
        UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:postVC];
        [self presentViewController:NC animated:YES completion:nil];
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
