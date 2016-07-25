//
//  PersonalTrendsViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PersonalTrendsViewController.h"
#import "TrendsModel.h"
#import "PersonalTrendsTableViewCell.h"
#import "NetworkingManager.h"
#import "TrendsDetailViewController.h"
#import "MJRefresh.h"

@interface PersonalTrendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

BOOL personalTrends = YES;

@implementation PersonalTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.navigationController.navigationBarHidden = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalTrendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"trendsListCell"];
    [self.view addSubview:self.tableView];
    
    //请求数据
    [self requestData];
    
    [self.tableView addHeaderWithTarget:self action:@selector(personalTrendsDowm)];
    
}
//实现下拉刷新方法
- (void)personalTrendsDowm {
    personalTrends = YES;
    [self requestData];
}

//请求数据
- (void)requestData {
    [NetworkingManager requestPOSTWithUrlString:kAllTrendsURL parDic:@{@"sToken":ksToken,@"userName":[[self.passDic objectForKey:@"personalInfo"] objectForKey:@"name"],@"requestUserId":[[self.passDic objectForKey:@"personalInfo"] objectForKey:@"userId"]} finish:^(id responseObject) {
        NSLog(@"----------%@",responseObject);
        [self.dataArray removeAllObjects];
        //解析数据
        NSArray *array = [responseObject objectForKey:@"customerFeedList"];
        if ([array isEqual:[NSNull null]]) {
            self.tableView.separatorStyle = NO;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, kDeviceWidth - 140, 40)];
            label.text = @"暂时没有帖子";
            label.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:label];
            return;
        }
        for (NSDictionary *dic in array) {
            TrendsModel *model = [[TrendsModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendsListCell" forIndexPath:indexPath];
    TrendsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell createContentLabelAndPictureView:model];
    [cell setValueFromModel:model];
    TrendsDetailViewController *detailVC = [[TrendsDetailViewController alloc] init];
    UINavigationController *NCDetail = [[UINavigationController alloc] initWithRootViewController:detailVC];
    //实现点击评论的block
    cell.presentCommentBlock = ^void(void) {
        detailVC.passModel = model;
        [self presentViewController:NCDetail animated:YES completion:nil];
    };
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat content = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
    if (content > 200) {
        content = 200;
    }
    CGFloat pictureView = [self pictureViewHeightWithAmmount:model.pictureList.count];
    return 130 + content + pictureView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
