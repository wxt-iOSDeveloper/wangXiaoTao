//
//  ActivityViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "UIButton+Action.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, strong) UIButton *nearButton;
@property (nonatomic, strong) UIButton *hotButton;
@property (nonatomic, strong) UIButton *willButton;

@end

@implementation ActivityViewController
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
    self.hotArray = [NSMutableArray array];
    //自定义标签视图
    UIImage *image = [UIImage imageNamed:@"activity.png"];//未选中时的图片
    //UIImage *selectImage = [[UIImage imageNamed:@"icon05_s@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//选中时显示的图片,并且设置图片的渲染模式为原始状态
    UITabBarItem *customItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:image];
    self.tabBarItem = customItem;
    self.tabBarItem.title = @"活动";
    //调整图标的位置  使用的是UITabBarItem从父类中继承过来的imageInsets属性(上,左,下,右)
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"周末活动";
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    [self.view addSubview:self.tableView];
    
    [self requestData];
}

//请求数据
- (void)requestData {
    //先清空数据源
    [self.hotArray removeAllObjects];
    NSString *tempURL = nil;
    if (self.nearButton.currentTitleColor == [UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1]) {
        //tempURL = kNearActivityURL;
    } else if (self.willButton.currentTitleColor == [UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1]) {
        //tempURL = kWillActivityURL;
    } else {
        //tempURL = kHotActivityURL;
    }
    [NetworkingManager requestPOSTWithUrlString:tempURL parDic:nil finish:^(id responseObject) {
        //解析数据
        NSLog(@"##########%@", responseObject);
    } error:^(NSError *error) {
        NSLog(@"请求出错");
    }];
}
//给tableView设置头部视图
- (void)setHeaderView {
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
    UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 50, 30)];
    provinceLabel.font = [UIFont boldSystemFontOfSize:15];
    provinceLabel.backgroundColor = [UIColor clearColor];
    provinceLabel.textColor = [UIColor whiteColor];
    [headerImageView addSubview:provinceLabel];
    self.tableView.tableHeaderView = headerImageView;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotArray.count;
}
//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    return cell;
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
//制定区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *tempArray = @[@"附近出发",@"最热活动",@"即将开始"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton setButtonWithFrame:CGRectMake(i * kDeviceWidth / 3, 0, kDeviceWidth / 3, 40) title:[tempArray objectAtIndex:i] target:self action:@selector(coloumButtonAction:)];
        button.tag = 800 + i;
        [view addSubview:button];
    }
    self.nearButton = [view viewWithTag:800];
    self.hotButton = [view viewWithTag:801];
    self.willButton = [view viewWithTag:802];
    return view;
}
- (void)coloumButtonAction:(UIButton *)sender {
    //点击重新请求数据
    //改变对应颜色
    if (sender.tag - 800 == 0) {
        [self.nearButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.willButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (sender.tag - 800 == 1 ) {
        [self.hotButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.willButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (sender.tag - 800 == 2) {
        [self.willButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
