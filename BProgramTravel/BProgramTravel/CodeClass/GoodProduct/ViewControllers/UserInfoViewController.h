//
//  UserInfoViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsModel.h"
#import "FansAndFouceModel.h"

@interface UserInfoViewController : UIViewController
@property (nonatomic, strong) TrendsModel *passModel;//接收传值
@property (nonatomic, strong) FansAndFouceModel *fansPassModel;//接收从粉丝和关注用户列表传来的model
@property (nonatomic, strong) NSString *passNameString;//接收从热门目的地帖子界面点击用户头像传来的数据
//记录是否是从关注和粉丝列表点击cell返回的 若是就重新请求数据
@property (nonatomic, assign) BOOL isClickCell;
@end
