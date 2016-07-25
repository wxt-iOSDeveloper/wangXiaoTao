//
//  MessageViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "MessageViewController.h"
#import "xiaoXiTableViewCell.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController
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
    UIImage *image = [UIImage imageNamed:@"message.png"];//未选中时的图片
    //UIImage *selectImage = [[UIImage imageNamed:@"icon05_s@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//选中时显示的图片,并且设置图片的渲染模式为原始状态
    UITabBarItem *customItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:image];
    self.tabBarItem = customItem;
    self.tabBarItem.title = @"消息";
    //调整图标的位置  使用的是UITabBarItem从父类中继承过来的imageInsets属性(上,左,下,右)
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"xiaoXiTableViewCell" bundle:nil] forCellReuseIdentifier:@"xiaoxi"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    xiaoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiaoxi" forIndexPath:indexPath];
    [cell setCellValueWithIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
