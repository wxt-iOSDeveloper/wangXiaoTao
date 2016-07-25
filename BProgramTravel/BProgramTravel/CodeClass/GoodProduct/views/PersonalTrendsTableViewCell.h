//
//  PersonalTrendsTableViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsModel.h"

@interface PersonalTrendsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, strong) UIView *addPictureView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *praiseImageView;
@property (strong, nonatomic) IBOutlet UILabel *praiseLabel;
@property (strong, nonatomic) IBOutlet UIImageView *commentImageView;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) TrendsModel *passModel;//调用block时传的实参
//点击评论图片 跳转页面
@property (nonatomic, copy) void(^presentCommentBlock)(void);

- (void)setValueFromModel:(TrendsModel *)model;
//给cell创建contentLabel和pictureView
- (void)createContentLabelAndPictureView:(TrendsModel *)model;
@end
