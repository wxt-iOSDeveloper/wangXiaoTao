//
//  TrendsDetailViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "BaseViewController.h"
#import "TrendsModel.h"

@interface TrendsDetailViewController : BaseViewController

//接收上一界面传来的动态model
@property (nonatomic, strong) TrendsModel *passModel;
//记录是否是点击评论进来的 若是 则要直接让tableView 滑动到评论列表
@property (nonatomic, assign) BOOL isEnterByComment;
@end
