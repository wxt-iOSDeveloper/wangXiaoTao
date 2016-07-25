//
//  TrendsTableViewCell.h
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsModel.h"
#import "UIImageView+AFNetworking.h"


@interface TrendsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIButton *focusButton;

@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;//头像
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;//用户名
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;//发表时间
@property (strong, nonatomic) UILabel *contentLable;//发表内容
@property (strong, nonatomic) UIView *addPictureView;//图片区
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;//位置
@property (strong, nonatomic) IBOutlet UIImageView *praiseImageView;//赞
@property (strong, nonatomic) IBOutlet UIImageView *commentImageView;//评论
@property (strong, nonatomic) IBOutlet UILabel *praiseCountLabel;//赞数量
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;//评论数量
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (nonatomic, strong) TrendsModel *passModel;//调用block时传的实参
//轻拍手势。点击事件的回调
@property (nonatomic, copy) void(^tapActionBlock)(TrendsModel *);

//点击评论图片 跳转页面
@property (nonatomic, copy) void(^presentCommentBlock)(void);

//给cell创建contentLabel和pictureView
- (void)createContentLabelAndPictureView:(TrendsModel *)model;


//封装用model给cell赋值的方法
- (void)setValueFromModel:(TrendsModel *)model;


@end
