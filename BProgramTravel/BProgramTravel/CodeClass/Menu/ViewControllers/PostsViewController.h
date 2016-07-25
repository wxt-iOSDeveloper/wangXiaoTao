//
//  PostsViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "BaseViewController.h"
#import "destinationModel.h"
#import "SearchResultModel.h"

@interface PostsViewController : BaseViewController

@property (nonatomic, strong) destinationModel *passParnterModel;//约伴界面传来的model
@property (nonatomic, strong) SearchResultModel *passSearchModel;//搜索界面传来的model
@property (nonatomic, strong) NSString *titleString;//接收标题
@property (nonatomic, strong) NSNumber *customerUserId;//查找用户所有约伴时用户的id

@end
