//
//  PostsTableViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsModel.h"

@interface PostsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *addImageView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;


- (void)setvaluesForCellWithModel:(PostsModel *)model;

@property (nonatomic, strong) PostsModel *passModel;//调用block时传的实参
//轻拍手势。点击事件的回调
@property (nonatomic, copy) void(^tapActionBlock)(PostsModel *);

@end
