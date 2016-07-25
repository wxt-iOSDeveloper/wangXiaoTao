//
//  MyAccountViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountHeaderView.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
#import "MapViewController.h"
#import "PersonalTrendsViewController.h"
#import "FansAndFoucsViewController.h"
#import "PostsViewController.h"
#import "LoginViewController.h"
@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *passDic;//要传到所有帖子界面的字典
@end

@implementation MyAccountViewController
//重写指定初始化方式,设置标签控制器上的图片或者标题
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //调用
        [self setupTabBarItem];
    }
    return self;
}

//给tabBar设置标签和标题
- (void)setupTabBarItem {
    //自定义标签视图
    UIImage *image = [UIImage imageNamed:@"my.png"];//未选中时的图片
    //UIImage *selectImage = [[UIImage imageNamed:@"icon05_s@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//选中时显示的图片,并且设置图片的渲染模式为原始状态
    UITabBarItem *customItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:image];
    self.tabBarItem = customItem;
    self.tabBarItem.title = @"我的";
    //调整图标的位置  使用的是UITabBarItem从父类中继承过来的imageInsets属性(上,左,下,右)
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"我的帖子",@"我的约伴",@"退出当前账号"];
    self.navigationItem.title = @"我的";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    [self.view addSubview:self.tableView];
    
    //请求头部视图数据
    [self requestData];
    
}

- (void)requestData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [NetworkingManager requestPOSTWithUrlString:kMyAccountURL parDic:@{@"sToken":ksToken,@"sourceUserId":kUserId,@"targetUserName":[userDefaults objectForKey:@"name"]} finish:^(id responseObject) {
        self.passDic = responseObject;
        //解析数据
        NSDictionary *bigDic = [responseObject objectForKey:@"CustomerUserDetail"];
        MyAccountHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"MyAccountHeaderView" owner:nil options:nil] firstObject];//获取UIView关联的xib
        view.frame = CGRectMake(0, 0, kDeviceWidth, 240);
        
        [view setViewWithDic:bigDic];
        view.bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view.bigImageView addGestureRecognizer:tap];
        
        [view.TrendsNumButton addTarget:self action:@selector(myAllTrendsAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.FansNumButton addTarget:self action:@selector(FansNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view.FocusNumButton addTarget:self action:@selector(FocusNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableHeaderView = view;
        
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}
//点击动态 跳转至动态列表
- (void)myAllTrendsAction:(UIButton *)sender {
    PersonalTrendsViewController *personalVC = [[PersonalTrendsViewController alloc] init];
    personalVC.passDic = [self.passDic objectForKey:@"CustomerUserDetail"];
    [self.navigationController pushViewController:personalVC animated:YES];
}
- (void)FansNumButtonAction:(UIButton *)sender {
    FansAndFoucsViewController *FAFVC = [[FansAndFoucsViewController alloc] init];
    FAFVC.isFans = YES;
    FAFVC.isEnterByMy = YES;
    FAFVC.targetUserId = [[[self.passDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
    [self.navigationController pushViewController:FAFVC animated:YES];
}
- (void)FocusNumButtonAction:(UIButton *)sender {
    FansAndFoucsViewController *FAFVC = [[FansAndFoucsViewController alloc] init];
    FAFVC.isFans = NO;
    FAFVC.isEnterByMy = YES;
    FAFVC.targetUserId = [[[self.passDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
    [self.navigationController pushViewController:FAFVC animated:YES];
}

//点击大图片 跳转至地图
- (void)tapAction:(UITapGestureRecognizer *)sender {
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapVC.ueserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    [self presentViewController:mapVC animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PersonalTrendsViewController *personalVC = [[PersonalTrendsViewController alloc] init];
        personalVC.passDic = [self.passDic objectForKey:@"CustomerUserDetail"];
        [self.navigationController pushViewController:personalVC animated:YES];
    } else if (indexPath.row == 1) {
        PostsViewController *postsVC = [[PostsViewController alloc] init];
        UINavigationController *NCPosts = [[UINavigationController alloc] initWithRootViewController:postsVC];
        postsVC.customerUserId = [[[self.passDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"userId"];
        postsVC.titleString = [[[self.passDic objectForKey:@"CustomerUserDetail"] objectForKey:@"personalInfo"] objectForKey:@"name"];
        [self presentViewController:NCPosts animated:YES completion:nil];
    } else {
        LoginViewController *loginVC =[[LoginViewController alloc] init];
        [NetworkingManager requestPOSTWithUrlString:kExitLoginURL parDic:nil finish:^(id responseObject) {
            [loginVC exitLogin];//先删除沙盒数据再跳转界面
            [self presentViewController:loginVC animated:YES completion:nil];
        } error:^(NSError *error) {
            
        }];
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
