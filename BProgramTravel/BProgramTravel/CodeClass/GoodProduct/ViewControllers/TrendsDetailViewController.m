//
//  TrendsDetailViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "TrendsDetailViewController.h"
#import "TrendsDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"
#import "TrendsDetailModel.h"
#import "KeyboardTextView.h"
#import "UserInfoViewController.h"
#import "MJRefresh.h"
@interface TrendsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,KeyboardTextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, strong) KeyboardTextView *keyBoardView;

@end

BOOL trendsDetailIsUp = YES;
int trendsDetailPage = 1;

@implementation TrendsDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isEnterByComment == YES) {
        //是点击评论进来的就让tableView滑动到评论
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帖子详情";
    self.commentsArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TrendsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"trendsDetailCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"firstCell"];
    [self.view addSubview:self.tableView];
    //cell自适应高度
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //给tableView设置头部视图
    [self createTabelViewHeaderView];
 
    //请求数据
    [self requestData];
    
    //上提加载
    [self.tableView addFooterWithTarget:self action:@selector(TrendsDetailCommentUpAction)];
    //导航条上返回按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"66.png"] style:UIBarButtonItemStyleDone target:self action:@selector(handleLeftBarButtonAction:)];
    //给左边添加item
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    //右按钮 发表评论
    UIBarButtonItem *addCommentItem = [[UIBarButtonItem alloc] initWithTitle:@"发表评论" style:UIBarButtonItemStyleDone target:self action:@selector(addCommentItemButtonAction:)];
    //self.navigationItem.rightBarButtonItem = addCommentItem;
}
//返回上一界面
- (void)handleLeftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)TrendsDetailCommentUpAction {
    trendsDetailIsUp = YES;
    trendsDetailPage += 1;
    [self requestData];
}

//设置头部视图
- (void)createTabelViewHeaderView {
    //先计算头部视图因图片数量和文字多少而造成的不同高度 再根据高度来创建头部视图
    CGFloat strHeight = [[NetworkingManager sharedNetWorkingMangaer] contentLabelHeightWithContent:[self.passModel.feed objectForKey:@"content"]];
    CGFloat imageHeight = 0;
    if (self.passModel.pictureList.count < 4 && self.passModel.pictureList.count != 0) {
        imageHeight = 80;
    } else if (self.passModel.pictureList.count > 6) {
        imageHeight = 250;
    } else if (self.passModel.pictureList.count == 0){
        imageHeight = 0;
    } else {
        imageHeight = 165;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, strHeight + imageHeight + 100)];
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [userImage setImageWithURL:[NSURL URLWithString:[self.passModel.author objectForKey:@"picUrl"]]];
    userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [userImage addGestureRecognizer:tapGes];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 150, 20)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.text = [self.passModel.author objectForKey:@"name"];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 35, 150, 15)];
    timeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[self.passModel.feed objectForKey:@"addTime"]];
    timeLabel.font = [UIFont boldSystemFontOfSize:13];
    timeLabel.textColor = [UIColor lightGrayColor];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kDeviceWidth - 20, strHeight)];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont boldSystemFontOfSize:15];
    contentLabel.text = [self.passModel.feed objectForKey:@"content"];
    for (int i = 0; i < self.passModel.pictureList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 3 * 85 + 20, i / 3 * 85 + strHeight + 60, 80, 80)];
        NSString *imageUrl = [[self.passModel.pictureList objectAtIndex:i] objectForKey:@"url"];
        [imageView setImageWithURL:[NSURL URLWithString:[kImageURL stringByAppendingString:imageUrl]]];
        [headerView addSubview:imageView];
    }
    UILabel *separatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, strHeight + imageHeight + 95, kDeviceWidth, 5)];
    separatorLabel.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    [headerView addSubview:separatorLabel];
    [headerView addSubview:userImage];
    [headerView addSubview:nameLabel];
    [headerView addSubview:timeLabel];
    [headerView addSubview:contentLabel];
    self.tableView.tableHeaderView = headerView;
    
    
    
    
}

//点击头像 跳转至个人信息页面
- (void)tapAction:(UITapGestureRecognizer *)sender {
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    userInfoVC.passModel = self.passModel;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}


//发表评论
- (void)addCommentItemButtonAction:(UIBarButtonItem *)sender {
    //弹出输入框操作
    //监测键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监测键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    //创建输入框
    if (self.keyBoardView == nil) {
        self.keyBoardView = [[KeyboardTextView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
    }
    //代理对象
    self.keyBoardView.delegate = self;
    //让键盘弹出
    [self.keyBoardView.textView becomeFirstResponder];
    [self.view.window addSubview:self.keyBoardView];
    
}

#pragma mark --- 实现键盘即将消失的方法
- (void)keyboardHide:(NSNotification *)notification {
    //获取键盘的高度
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//将字符串转为CGRect结构体
    //[NSValue valueWithCGRect:()]  --- 对象转为结构体
    //获取键盘收回需要的时间
    float time = [[notification.userInfo objectForKey:UIKeyboardWillHideNotification] floatValue];
    //现在使用动画改变keyboardView的位置 英文键盘高度216 中文键盘256
    [UIView animateWithDuration:time animations:^{
        //输入框向下移动一个键盘高度
        self.keyBoardView.transform = CGAffineTransformMakeTranslation(0, keyboardRect.size.height);
        self.keyBoardView.textView.text = @"";//发送完后输入框清空
        //并且从父视图上移除
        [self.keyBoardView removeFromSuperview];
    }];
    
    if (self.keyBoardView.textView.frame.size.height > 44) {
        CGRect frame =  self.keyBoardView.frame;
        frame.size.height = 44;
        frame.origin.y += 18;
        self.keyBoardView.frame = frame;
        CGRect keyboardFrame = self.keyBoardView.textView.frame; keyboardFrame.size.height = 44 - 10;
        self.keyBoardView.textView.frame = keyboardFrame;
    }
    self.keyBoardView.isChange = NO;
}
#pragma mark -- 实现键盘即将出现的方法
- (void)keyboardShow:(NSNotification *)notification {
    //同样, 获取键盘的高度
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //获取键盘回收需要的时间
    float time = [[notification.userInfo objectForKey:UIKeyboardWillShowNotification] floatValue];
    //以高度和时间来做动画
    [UIView animateWithDuration:time animations:^{
        //输入框向上移动一个键盘的高度
        self.keyBoardView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);//向下移动是正方向,向上移动是反方向
    }];
}
#pragma mark -- 实现textView代理方法
- (void)keyboardView:(UITextView *)aTextView {
    
    //网络请求 向服务器发送评论内容
    //NSDictionary *dic = @{@"content":content,@"sourceId":[self.passModel.feed objectForKey:@"feedId"],@"toUserId":[self.passModel.author objectForKey:@"userId"],@"type":[self.passModel.feed objectForKey:@"type"],@"userId":kUserId};
    NSString *dicStr = [NSString stringWithFormat:@"{content:'%@',sourceId:%@,toUserId:%@,type:%@,userId:%@}",aTextView.text,[self.passModel.feed objectForKey:@"feedId"],[self.passModel.author objectForKey:@"userId"],[self.passModel.feed objectForKey:@"type"],kUserId];
    NSDictionary *dicPara = @{@"sToken":ksToken,@"reply":dicStr};
    //开始请求
    [NetworkingManager requestPOSTWithUrlString:kAddCommentURL parDic:dicPara finish:^(id responseObject) {
        if ([responseObject objectForKey:@"id"]) {
            // id 存在 评论成功
            /*
            //创建model 根据model直接插入cell
            TrendsDetailModel *model = [[TrendsDetailModel alloc] init];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *userBasic = @{@"userId":kUserId,@"name":[userDefault objectForKey:@"name"],@"picUrl":[userDefault objectForKey:@"picUrl"]};
            NSDictionary *reply = @{@"content":content,@"time":@"刚刚"};
            NSDictionary *bigDic = @{@"userBasic":userBasic,@"reply":reply};
            [model setValuesForKeysWithDictionary:bigDic];
            [self.commentsArray insertObject:model atIndex:0];
            // 插入cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            //同时将评论数量修改
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:firstIndexPath];
            NSString *str = @"评论 ";
            firstCell.textLabel.text = [str stringByAppendingString:[NSString stringWithFormat:@"%ld",self.commentsArray.count]];
             */
            [self.commentsArray removeAllObjects];
            [self requestData];
        } else {
            NSLog(@"%@", responseObject);
            NSLog(@"%@", [responseObject objectForKey:@"errorDetail"]);
        }
    } error:^(NSError *error) {
        
    }];
    //释放第一响应者 收回键盘
    [aTextView resignFirstResponder];
}

#pragma mark -- 界面即将消失 收回键盘
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.keyBoardView != nil) {
        [self.keyBoardView.textView resignFirstResponder];
    }
}
//请求数据
- (void)requestData {
    NSString *pageStr = [NSString stringWithFormat:@"%d",trendsDetailPage];
    [NetworkingManager requestPOSTWithUrlString:kRequestCommentURL parDic:@{@"sToken":ksToken,@"feedId":[self.passModel.feed objectForKey:@"feedId"],@"page":pageStr} finish:^(id responseObject) {
        //解析数据
        NSArray *tempArray = [responseObject objectForKey:@"customerReplyList"];
        //如果没有评论 就跳过遍历封装
        if (![tempArray isEqual:[NSNull null]]) {
        for (NSDictionary *dic in tempArray) {
            TrendsDetailModel *model = [[TrendsDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.commentsArray addObject:model];
            }
        }
        //数据请求完之后 数组为空 就关闭分割线
        if (self.commentsArray.count == 0) {
            self.tableView.separatorStyle = NO;
        }
        //回主线程刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        });
        
    } error:^(NSError *error) {
        NSLog(@"请求出错");
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count + 1;//加1是为了给第一个cell赋值为评论的总数量
}
//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    if (self.commentsArray.count == 0) {
        firstCell.textLabel.text = @"暂无评论";
        firstCell.textLabel.textAlignment = NSTextAlignmentCenter;
        return firstCell;
    }
    if (indexPath.row == 0) {
        NSString *str = @"评论 ";
        firstCell.textLabel.text = [str stringByAppendingString:[NSString stringWithFormat:@"%ld",self.commentsArray.count]];
        firstCell.textLabel.textAlignment = NSTextAlignmentLeft;
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中时的灰色阴影
        return firstCell;
    }
    if (self.commentsArray.count == 0) {
        return nil;
    }
    TrendsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendsDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TrendsDetailModel *model = [self.commentsArray objectAtIndex:indexPath.row - 1];
    [cell setValueWithModel:model];
    cell.tapActionBlock = ^void () {
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
