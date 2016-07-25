//
//  PartnerViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PartnerViewController.h"
#import "destinationModel.h"
#import "messageBoardModel.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"
#import "MessageTableViewCell.h"
#import "messageCollectionViewCell.h"
#import "UIButton+Action.h"
#import "SearchViewController.h"
#import "PostsViewController.h"
#import "MJRefresh.h"
#import "MapViewController.h"
@interface PartnerViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//展示留言
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *hotDestinationArray;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSDictionary *bigImageDic;
@end

BOOL partnerIsDown = YES;

@implementation PartnerViewController
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
    UIImage *image = [UIImage imageNamed:@"partner.png"];//未选中时的图片
    UITabBarItem *customItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:image];
    self.tabBarItem = customItem;
    self.tabBarItem.title = @"约伴";
    //调整图标的位置  使用的是UITabBarItem从父类中继承过来的imageInsets属性(上,左,下,右)
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotDestinationArray = [NSMutableArray array];
    self.messageArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kDeviceWidth, kDeviceHeight - 150 - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    [self.view addSubview:self.tableView];
    [self showProgressHUDWithString:@"玩命加载中..."];
    //请求数据
    [self requsetData];
    
    [self.tableView addHeaderWithTarget:self action:@selector(partnerDownAction)];
}
//实现下拉刷新方法
- (void)partnerDownAction {
    partnerIsDown = YES;
    [self requsetData];
}
//布局tableView的headerView
- (void)setTableViewHeaderView {
    UIView *desView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 170)];
    desView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    nameLabel.text = @"  热门目的地";
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    [desView addSubview:nameLabel];
    UIScrollView *desScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, 130)];
    desScroll.contentSize = CGSizeMake(self.hotDestinationArray.count * 100, 110);
    for (int i = 0; i < self.hotDestinationArray.count; i++) {
        destinationModel *model = [self.hotDestinationArray objectAtIndex:i];
        UIImageView *desImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * 90, 10, 80, 80)];
        desImageView.userInteractionEnabled = YES;//必须打开imageView的用户交互
        desImageView.layer.cornerRadius = 40;
        desImageView.layer.masksToBounds = YES;
        [desImageView setImageWithURL:[NSURL URLWithString:[model.terminiPicture objectForKey:@"url"]]];
        //把每个imageView上添加一个透明button  点击不同的imageView 根据button的tag值来找到对应的model
        UIButton *button = [UIButton setButtonWithFrame:CGRectMake(0, 0, 80, 80) title:nil target:self action:@selector(clickButtonAction:)];
        [desImageView addSubview:button];
        button.tag = 666 + i;
        

        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * 90, 100, 80, 20)];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.font = [UIFont boldSystemFontOfSize:12];
        desLabel.textColor = [UIColor lightGrayColor];
        desLabel.tag = 700 + i;
        if ([model.isChina intValue] == 0) {
            //其它国家显示国家名
            desLabel.text = [model.nationInfo objectForKey:@"name"];
        } else {
            if (!model.cityInfo) {
                desLabel.text = [model.provinceInfo objectForKey:@"name"];
            } else {
                desLabel.text = [model.cityInfo objectForKey:@"name"];
            }
        }
        [desScroll addSubview:desImageView];
        [desScroll addSubview:desLabel];
    }
    [desView addSubview:desScroll];
    self.tableView.tableHeaderView = desView;
}

//最热城市的点击事件
- (void)clickButtonAction:(UIButton *)sender {
    destinationModel *model = [self.hotDestinationArray objectAtIndex:sender.tag - 666];
    UILabel *label = [self.view viewWithTag:sender.tag - 666 + 700];
    PostsViewController *postsVC = [[PostsViewController alloc] init];
    UINavigationController *NCPostVC = [[UINavigationController alloc] initWithRootViewController:postsVC];
    //传值
    postsVC.passParnterModel = model;
    postsVC.titleString = label.text;
    [self presentViewController:NCPostVC animated:YES completion:nil];
}

//请求数据
- (void)requsetData {
    [NetworkingManager requestPOSTWithUrlString:kPartnerURL parDic:@{@"sToken":ksToken,@"lng":[NSString stringWithFormat:@"%f",self.lng],@"lat":[NSString stringWithFormat:@"%f",self.lat]}finish:^(id responseObject) {
        
        [self.hotDestinationArray removeAllObjects];
        [self.messageArray removeAllObjects];
        //解析数据  给不同的数据源数组赋值
        NSArray *desArray = [responseObject objectForKey:@"customerHotHierarchicalTerminiList"];
        for (NSDictionary *dic in desArray) {
            destinationModel *model = [[destinationModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.hotDestinationArray addObject:model];
        }
        NSArray *tempMessArray = [responseObject objectForKey:@"customerNearbyLeaveWordList"];
        for (NSDictionary *dic in tempMessArray) {
            messageBoardModel *model = [[messageBoardModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.messageArray addObject:model];
        }
        self.bigImageDic = [responseObject objectForKey:@"CustomerInvitePeopleCountByLocation"];
        //页面大图片
        UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
        [bigImageView setImage:[UIImage imageNamed:@"11111.png"]];
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 70, 30)];
        //areaLabel.text = [self.bigImageDic objectForKey:@"areaName"];
        areaLabel.text = self.cityName;
        areaLabel.textColor = [UIColor whiteColor];
        areaLabel.backgroundColor = [UIColor clearColor];
        [bigImageView addSubview:areaLabel];
        [self.view addSubview:bigImageView];
        bigImageView.userInteractionEnabled = YES;
        UIButton *searchButton = [UIButton setButtonWithFrame:CGRectMake(20, 100, kDeviceWidth - 40, 25) title:@"🔍你想去的城市或者国家" target:self action:@selector(searchButtonAction:)];
        searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        searchButton.backgroundColor = [UIColor whiteColor];
        [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        searchButton.layer.cornerRadius = 5;
        searchButton.layer.masksToBounds = YES;
        [bigImageView addSubview:searchButton];
        //布局tableView的headerView
        [self setTableViewHeaderView];
        //刷新页面
        [self hideProgressHUD];
        [self.tableView headerEndRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        NSLog(@"请求出错");
    }];
}

//点击搜索按钮 模态进入搜索界面
- (void)searchButtonAction:(UIButton *)sender {
    SearchViewController *searchVC = [[SearchViewController alloc] init];

    [self presentViewController:searchVC animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.detailButton.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    //点击附近约伴留言板进入地图页面
    [cell.detailButton addTarget:self action:@selector(detailButtonMapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消选中cell时的灰色阴影
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.messageArray.count == 0) {
        self.tableView.separatorStyle = NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 100, kDeviceWidth - 140, 40)];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"暂时没有留言";
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
        return cell;
    }
    //创建layout布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置左右最小间距
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 10;//上下最小间距
    //设置item大小
    layout.itemSize = CGSizeMake((kDeviceWidth - 75) / 2, 150);
    //设置分区边界
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    //创建集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kDeviceWidth, 200 * (self.messageArray.count / 2 + self.messageArray.count % 2)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"messageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    //添加到cell上
    [cell addSubview:self.collectionView];
    return cell;
}

//进入地图页面
- (void)detailButtonMapAction:(UIButton *)sender {
    MapViewController *mapVC = [[MapViewController alloc] init];
    for (messageBoardModel *model in self.messageArray) {
        CGPoint point = CGPointMake([[model.nearbyLeaveWord objectForKey:@"lng"] floatValue], [[model.nearbyLeaveWord objectForKey:@"lat"] floatValue]);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [mapVC.pointArray addObject:value];
    }
    [self presentViewController:mapVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200 * (self.messageArray.count / 2 + self.messageArray.count % 2);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    messageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    messageBoardModel *model = [self.messageArray objectAtIndex:indexPath.row];
    [cell setCollectionCellWithModel:model];
    return cell;
}




#pragma mark -- 显示文字提醒的loading
- (void)showProgressHUDWithString:(NSString *)title {
    if (title.length == 0) {
        self.HUD.labelText = nil;
    } else {
        self.HUD.labelText = title;
    }
    //调用第三方显示loading
    [self.HUD show:YES];
}

#pragma mark -- 隐藏
- (void)hideProgressHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];//移除,释放HUD对象
        self.HUD = nil;//指针置为nil,防止后面再调用崩溃
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
