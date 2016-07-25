//
//  FansAndFoucsViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/20.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoViewController.h"
@interface FansAndFoucsViewController : BaseViewController

@property (nonatomic, strong) NSNumber *targetUserId;//接收传过来的用户id
@property (nonatomic, assign) BOOL isFans;//记录是点击粉丝进来的还是关注进来的
@property (nonatomic, strong) UserInfoViewController *controller;//用来接收用户信息界面的控制器 将用户信息的控制器带到下一界面 就可以在返回的时候利用属性传值
@property (nonatomic, assign) BOOL isEnterByMy;//记录是否是从我的页面点击进入的 是的话 在点击cell时就进入用户信息界面  不是的话就pop到上一界面 刷新数据
@end
