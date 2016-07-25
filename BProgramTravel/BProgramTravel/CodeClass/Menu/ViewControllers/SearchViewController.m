//
//  SearchViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "SearchViewController.h"
#import "UIButton+Action.h"
#import "SearchTableViewCell.h"
#import "SearchResultModel.h"
#import "NetworkingManager.h"
#import "PostsViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;//热门数据源
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索数据源
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];

    //创建搜索框和 取消返回按钮
    [self createTextFieldAndBackButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kDeviceWidth, kDeviceHeight - 60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    [self.view addSubview:self.tableView];
    
    //请求数据
    [self requsetData];
}

- (void)createTextFieldAndBackButton {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    //UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 25, kDeviceWidth - 10 - 60, 30)];
    self.searchBar.delegate = self;
    //self.searchBar.backgroundColor = [UIColor redColor];
    self.searchBar.placeholder = @"请输入想去的城市或者国家";
    [aView addSubview:self.searchBar];
    
    UIButton *backButton = [UIButton setButtonWithFrame:CGRectMake(kDeviceWidth - 50, 25, 40, 30) title:@"取消" target:self action:@selector(backButtonAction:)];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [aView addSubview:backButton];
    [self.view addSubview:aView];
}

- (void)backButtonAction:(UIButton *)sender {
    //模态返回上一界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //先清空存放搜索结果的数据源数组
    [self.searchArray removeAllObjects];
    //点击send之后 就开始请求数据
    [NetworkingManager requestPOSTWithUrlString:kSearchURL parDic:@{@"sToken":ksToken,@"keyWord":self.searchBar.text} finish:^(id responseObject) {
        //解析数据
        NSArray *array = [responseObject objectForKey:@"customerHierarchicalTerminiList"];
        NSLog(@"11111%@",array);
        if ([array isEqual:[NSNull null]]) {//没搜索到时就给提示框说明没找到
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有找到结果" preferredStyle:UIAlertControllerStyleAlert];
            //  确定事件
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [control addAction:confirm];
            //  弹出警示框
            [self presentViewController:control animated:YES completion:nil];
            return;
        }
            for (NSDictionary *dic in array) {
            SearchResultModel *model = [[SearchResultModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.searchArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];

}

//请求数据
- (void)requsetData {
    //先清空数据源
    [self.dataArray removeAllObjects];
    [NetworkingManager requestPOSTWithUrlString:kSearchVCURL parDic:@{@"sToken":ksToken} finish:^(id responseObject) {
       //解析数据
        NSArray *array = [responseObject objectForKey:@"CustomerHotHierarchicalTerminiList"];
        for (NSDictionary *dic in array) {
            SearchResultModel *model = [[SearchResultModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchArray.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchArray.count != 0) {
        if (section == 0) {
            if (self.searchArray.count == 0) {
                return 0;
            } else {
                return self.searchArray.count;
            }
        }
    }
    return self.dataArray.count;
}
//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.searchArray.count == 0) {
        SearchResultModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell setValueWithModel:model];
        return cell;
    }
    //查询有结果
    if (indexPath.section == 0) {
        if (self.searchArray.count != 0) {
            SearchResultModel *model = [self.searchArray objectAtIndex:indexPath.row];
            [cell setValueWithModel:model];
        }
    } else {
    SearchResultModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setValueWithModel:model];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//设置区头标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    if (self.searchArray.count == 0) {
        label.text = @"  热门城市";
    } else {
        if (section == 0) {
            label.text = @"  搜索结果";
        } else if (section == 1){
            label.text = @"  热门城市";
        }
    }
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultModel *model = [[SearchResultModel alloc] init];
    if (indexPath.section == 0 && self.searchArray.count != 0) {
        model = [self.searchArray objectAtIndex:indexPath.row];
    } else {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    SearchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //跳转至目的地帖子列表界面
    PostsViewController *postsVC = [[PostsViewController alloc] init];
    UINavigationController *NCPosts = [[UINavigationController alloc] initWithRootViewController:postsVC];
    //传值
    postsVC.passSearchModel = model;
    postsVC.titleString = cell.cityLabel.text;
    [self presentViewController:NCPosts animated:YES completion:nil];
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
