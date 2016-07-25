//
//  TrendsViewController.m
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "TrendsViewController.h"
#import "UIButton+Action.h"
#import "TrendsTableViewCell.h"
#import "TrendsModel.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"
#import "TrendsDetailViewController.h"
#import "UserInfoViewController.h"
#import "MJRefresh.h"
#import "MyAccountViewController.h"
@interface TrendsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

//标题栏目数据源
@property (nonatomic, strong) NSArray *coloumArray;

@property (nonatomic, strong) UIView *coloumView;
@property (nonatomic, strong) UIScrollView *bigScroll;

@property (nonatomic, strong) UITableView *focusTableView;
@property (nonatomic, strong) NSMutableArray *focusDataArray;
@property (nonatomic, strong) UITableView *hotTableView;
@property (nonatomic, strong) NSMutableArray *hotDataArray;
@property (nonatomic, strong) UITableView *nearTableView;
@property (nonatomic, strong) NSMutableArray *nearDataArray;

@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIButton *hotButton;
@property (nonatomic, strong) UIButton *nearButton;

@end

BOOL trendsIsDown = YES;
int trendsPage = 1;
@implementation TrendsViewController
//懒加载创建对象
- (MBProgressHUD *)HUD {
    if (_HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];//谁调用self.view就是谁
        [self.view addSubview:_HUD];
    }
    return _HUD;
}
- (NSArray *)coloumArray {
    if (_coloumArray == nil) {
        self.coloumArray = [NSArray array];
    }
    return _coloumArray;
}
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
    UIImage *image = [UIImage imageNamed:@"home.png"];//未选中时的图片
    //UIImage *selectImage = [[UIImage imageNamed:@"icon05_s@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//选中时显示的图片,并且设置图片的渲染模式为原始状态
    UITabBarItem *customItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:image];
    self.tabBarItem = customItem;
    self.tabBarItem.title = @"首页";
    //调整图标的位置  使用的是UITabBarItem从父类中继承过来的imageInsets属性(上,左,下,右)
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //给数据源数组开空间
    self.focusDataArray = [NSMutableArray array];
    self.hotDataArray = [NSMutableArray array];
    self.nearDataArray = [NSMutableArray array];
    self.coloumArray = @[@"关注",@"热门",@"附近"];
    //创建栏目和滑动视图
    [self createColoumListScrollView];
    self.navigationItem.title = @"动态";
    //活动指示器
    [self showProgressHUDWithString:@"玩命加载中..."];
    //请求数据
    [self requestDataWithName:@"focus"];
    [self requestDataWithName:@"hot"];
    [self requestDataWithName:@"near"];
    
    [self.focusTableView addHeaderWithTarget:self action:@selector(focusDownAction)];
    [self.hotTableView addHeaderWithTarget:self action:@selector(hotDownAction)];
    [self.nearTableView addHeaderWithTarget:self action:@selector(nearDownAction)];
    [self.focusTableView addFooterWithTarget:self action:@selector(focusUpAction)];
    [self.hotTableView addFooterWithTarget:self action:@selector(hotUpAction)];
    [self.nearTableView addFooterWithTarget:self action:@selector(nearUpAction)];
}
//实现下拉刷新
- (void)focusDownAction {
    trendsIsDown = YES;
    trendsPage = 1;
    [self requestDataWithName:@"focus"];
}
- (void)hotDownAction {
    trendsIsDown = YES;
    trendsPage = 1;
    [self requestDataWithName:@"hot"];
}
- (void)nearDownAction {
    trendsIsDown = YES;
    trendsPage = 1;
    [self requestDataWithName:@"near"];
}
//实现上提加载
- (void)focusUpAction {
    trendsIsDown = NO;
    trendsPage += 1;
    [self requestDataWithName:@"focus"];
}
- (void)hotUpAction {
    trendsIsDown = NO;
    trendsPage += 1;
    [self requestDataWithName:@"hot"];
}
- (void)nearUpAction {
    trendsIsDown = NO;
    trendsPage += 1;
    [self requestDataWithName:@"near"];
}
//封装创建栏目视图和滑动视图方法
- (void)createColoumListScrollView {
    self.coloumView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
    self.coloumView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton setButtonWithFrame:CGRectMake(i * kDeviceWidth / 3, 0, kDeviceWidth / 3, 40) title:[self.coloumArray objectAtIndex:i] target:self action:@selector(coloumButtonAction:)];
        button.tag = 600 + i;
        [self.coloumView addSubview:button];
    }
    [self.view addSubview:self.coloumView];
    self.focusButton = [self.coloumView viewWithTag:600];
    self.hotButton = [self.coloumView viewWithTag:601];
    self.nearButton = [self.coloumView viewWithTag:602];
    //滑动视图
    self.bigScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, kDeviceWidth, kDeviceHeight - 89)];
    self.bigScroll.delegate = self;
    self.bigScroll.contentSize = CGSizeMake(kDeviceWidth * 3, kDeviceHeight - 89);
    self.bigScroll.backgroundColor = [UIColor whiteColor];
    //初始偏移量偏移量
    self.bigScroll.contentOffset = CGPointMake(kDeviceWidth, 0);
    //默认展示的是热门界面 将对于的热门按钮改为绿色
    [self.hotButton setTitleColor:[UIColor colorWithRed:84 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
    self.bigScroll.pagingEnabled = YES;//整屏滚动
    self.bigScroll.directionalLockEnabled = YES;//锁定滑动方向
    self.bigScroll.bounces = YES;//关闭边界回弹
    [self.view addSubview:self.bigScroll];
    //创建表视图
    self.focusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 89 - 64) style:UITableViewStylePlain];
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, kDeviceHeight - 89 - 64 ) style:UITableViewStylePlain];
    
    self.nearTableView = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth * 2, 0, kDeviceWidth, kDeviceHeight - 89 - 64) style:UITableViewStylePlain];
    self.focusTableView.delegate = self;
    self.focusTableView.dataSource = self;
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    self.nearTableView.delegate = self;
    self.nearTableView.dataSource = self;
    self.focusTableView.separatorStyle = NO;
    self.hotTableView.separatorStyle = NO;
    self.nearTableView.separatorStyle = NO;
    [self.focusTableView registerNib:[UINib nibWithNibName:@"TrendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"focusCell"];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"TrendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotCell"];
    [self.nearTableView registerNib:[UINib nibWithNibName:@"TrendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"nearCell"];
    [self.bigScroll addSubview:self.focusTableView];
    [self.bigScroll addSubview:self.hotTableView];
    [self.bigScroll addSubview:self.nearTableView];
}

//button的点击事件
- (void)coloumButtonAction:(UIButton *)sender {
    //点击不同的button 更换不同的链接
    if (sender.tag - 600 == 0 && self.bigScroll.contentOffset.x != 0) {
        self.bigScroll.contentOffset = CGPointMake(0, 0);
        [self.focusButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (sender.tag - 600 == 1 && self.bigScroll.contentOffset.x != kDeviceWidth) {
        self.bigScroll.contentOffset = CGPointMake(kDeviceWidth, 0);
        [self.hotButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (sender.tag - 600 == 2 && self.bigScroll.contentOffset.x != kDeviceWidth * 2) {
        self.bigScroll.contentOffset = CGPointMake(kDeviceWidth * 2, 0);
        [self.nearButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
//当滑动视图改变时,在减速结束方法中改变button状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //判断只有是滑动视图才需要修改
    //tableView继承自scrollView,要是不这样判断,在滑动tableView结束后也会走这个方法
    if (scrollView == self.bigScroll) {
        if (self.bigScroll.contentOffset.x == 0) {
            [self.focusButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
            [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        } else if (self.bigScroll.contentOffset.x == kDeviceWidth) {
            [self.hotButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
            [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.nearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        } else {
            [self.nearButton setTitleColor:[UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1] forState:UIControlStateNormal];
            [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

//请求数据
- (void)requestDataWithName:(NSString *)name {
    NSString *pageStr = [NSString stringWithFormat:@"%d",trendsPage];
    //滑动视图偏移量不同时 接口不同
    NSString *tempURL = nil;
    if ([name isEqualToString:@"focus"]) {
        //重新请求数据时要把数据源数组清空
        if (trendsIsDown == YES) {
            [self.focusDataArray removeAllObjects];
        }
        [NetworkingManager requestPOSTWithUrlString:kFocusURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"page":pageStr} finish:^(id responseObject) {
            [self praiserDataWithResponse:responseObject name:name];
        } error:^(NSError *error) {
            
        }];
    } else if ([name isEqualToString:@"hot"]) {
        if (trendsIsDown == YES) {
            [self.hotDataArray removeAllObjects];
        }
        [NetworkingManager requestPOSTWithUrlString:kHotURL parDic:@{@"sToken":ksToken,@"sourceUserId":kUserId,@"page":pageStr} finish:^(id responseObject) {
            [self praiserDataWithResponse:responseObject name:name];
        } error:^(NSError *error) {
            
        }];
    } else if ([name isEqualToString:@"near"]) {
        tempURL = [kNearURL stringByAppendingString:kUserId];
        if (trendsIsDown == YES) {
            [self.nearDataArray removeAllObjects];
        }
        [NetworkingManager requestPOSTWithUrlString:kNearURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"lng":[NSString stringWithFormat:@"%f",self.lng],@"lat":[NSString stringWithFormat:@"%f",self.lat],@"page":pageStr} finish:^(id responseObject) {
            [self praiserDataWithResponse:responseObject name:name];
        } error:^(NSError *error) {
            
        }];

    }
}
//解析数据
- (void)praiserDataWithResponse:(id)responseObject name:(NSString *)name {
    //解析数据
    NSArray *tempArray = [responseObject objectForKey:@"customerFeedList"];
    //遍历
    for (NSDictionary *dic in tempArray) {
        TrendsModel *model = [[TrendsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        if ([name isEqualToString:@"focus"]) {
            [self.focusDataArray addObject:model];
        } else if ([name isEqualToString:@"hot"]) {
            [self.hotDataArray addObject:model];
        } else if ([name isEqualToString:@"near"]) {
            [self.nearDataArray addObject:model];
        }
    }
    NSLog(@"--------%@", self.hotDataArray);
    //遍历结束  回主线程刷新tableView
    //关闭活动指示器
    [self hideProgressHUD];
    if ([name isEqualToString:@"focus"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.focusTableView headerEndRefreshing];
            [self.focusTableView footerEndRefreshing];
            [self.focusTableView reloadData];
        });
    } else if ([name isEqualToString:@"hot"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hotTableView headerEndRefreshing];
            [self.hotTableView footerEndRefreshing];
            [self.hotTableView reloadData];
        });
    } else if ([name isEqualToString:@"near"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.nearTableView headerEndRefreshing];
            [self.nearTableView footerEndRefreshing];
            [self.nearTableView reloadData];
        });
    }

}

//配置表视图
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.focusTableView) {
        return self.focusDataArray.count;
    } else if (tableView == self.hotTableView) {
        return self.hotDataArray.count;
    }
    return self.nearDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsDetailViewController *detailVC = [[TrendsDetailViewController alloc] init];
    UINavigationController *NCDetail = [[UINavigationController alloc] initWithRootViewController:detailVC];

    if (tableView == self.focusTableView) {
        TrendsModel *model = [self.focusDataArray objectAtIndex:indexPath.row];
        TrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell createContentLabelAndPictureView:model];
        //给cell赋值
        [cell setValueFromModel:model];
        //实现block
        cell.tapActionBlock = ^void(TrendsModel *passModel) {
            if ([[[passModel.author objectForKey:@"userId"] stringValue] isEqualToString:kUserId]) {
                MyAccountViewController *myVC = [[MyAccountViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                //点击图片跳转界面
                UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
                userInfo.passModel = passModel;
                [self.navigationController pushViewController:userInfo animated:YES];
            }
        };
        cell.presentCommentBlock = ^void(void) {
            detailVC.passModel = model;
            detailVC.isEnterByComment = YES;
            [self presentViewController:NCDetail animated:YES completion:nil];
        };
        return cell;
    } else if (tableView == self.hotTableView) {
        TrendsModel *model = [self.hotDataArray objectAtIndex:indexPath.row];
        TrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell createContentLabelAndPictureView:model];
        //给cell赋值
        [cell setValueFromModel:model];
        //实现block
        cell.tapActionBlock = ^void(TrendsModel *passModel) {
            if ([[[passModel.author objectForKey:@"userId"] stringValue] isEqualToString:kUserId]) {
                MyAccountViewController *myVC = [[MyAccountViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                //点击图片跳转界面
                UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
                userInfo.passModel = passModel;
                [self.navigationController pushViewController:userInfo animated:YES];
            }
        };

        cell.presentCommentBlock = ^void(void) {
            detailVC.passModel = model;
            detailVC.isEnterByComment = YES;
            [self presentViewController:NCDetail animated:YES completion:nil];
        };
        return cell;
    }
    TrendsModel *model = [self.nearDataArray objectAtIndex:indexPath.row];
    TrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearCell" forIndexPath:indexPath];
    [cell createContentLabelAndPictureView:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //给cell赋值
    [cell setValueFromModel:model];
    //实现block
    cell.tapActionBlock = ^void(TrendsModel *passModel) {
        if ([[[passModel.author objectForKey:@"userId"] stringValue] isEqualToString:kUserId]) {
            MyAccountViewController *myVC = [[MyAccountViewController alloc] init];
            [self.navigationController pushViewController:myVC animated:YES];
        } else {
            //点击图片跳转界面
            UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
            userInfo.passModel = passModel;
            [self.navigationController pushViewController:userInfo animated:YES];
        }
    };
    cell.presentCommentBlock = ^void(void) {
        detailVC.passModel = model;
        detailVC.isEnterByComment = YES;
        [self presentViewController:NCDetail animated:YES completion:nil];
    };
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat content = 0;
    CGFloat pictureView = 0;
    if (tableView == self.focusTableView) {
        TrendsModel *model = [self.focusDataArray objectAtIndex:indexPath.row];
        content = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
        pictureView = [self pictureViewHeightWithAmmount:model.pictureList.count];
    } else if (tableView == self.hotTableView) {
        TrendsModel *model = [self.hotDataArray objectAtIndex:indexPath.row];
        content = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
        pictureView = [self pictureViewHeightWithAmmount:model.pictureList.count];
    } else if (tableView == self.nearTableView) {
        TrendsModel *model = [self.nearDataArray objectAtIndex:indexPath.row];
        content = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
        pictureView = [self pictureViewHeightWithAmmount:model.pictureList.count];
    }
    if (content > 200) {
        content = 200;//保证cell高度不会太高
    }
    return 136 + content + pictureView;
}
//计算高度
- (CGFloat)contentLabelHeightWithContent:(NSString *)contet {
    //能影响字符串高度的元素有字符串本身的字号以及展示的宽度
    //1.将计算的文本的字号进行设置
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    //2.通过以下方法计算得到字符串的高度
    //注意:参数1,用来确定文本的宽度
    //参数2:设置计量标准(比如行间距也要计算,使结果更精确)
    //参数3:确定字号大小
    CGRect rect = [contet boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 64, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.height;
}
- (CGFloat)pictureViewHeightWithAmmount:(NSInteger)ammount {
    if (ammount <= 3 && ammount > 0) {
        return 80;
    } else if (ammount > 3 && ammount <= 6) {
        return 165;
    } else if (ammount == 0){
        return 0;
    } else {
        return 250;
    }
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

//点击cell跳转至详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsDetailViewController *detailVC = [[TrendsDetailViewController alloc] init];
    UINavigationController *NCDetail = [[UINavigationController alloc] initWithRootViewController:detailVC];
    //根据当前偏移量的不同选择不同的数据源数组传递model
    if (self.bigScroll.contentOffset.x == 0) {
        detailVC.passModel = [self.focusDataArray objectAtIndex:indexPath.row];
    } else if (self.bigScroll.contentOffset.x == kDeviceWidth) {
        detailVC.passModel = [self.hotDataArray objectAtIndex:indexPath.row];
    } else {
        detailVC.passModel = [self.nearDataArray objectAtIndex:indexPath.row];
    }
    //模态
    [self.navigationController presentViewController:NCDetail animated:YES completion:nil];
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
