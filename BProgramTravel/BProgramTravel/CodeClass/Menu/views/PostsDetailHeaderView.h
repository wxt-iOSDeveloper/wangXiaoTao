//
//  PostsDetailHeaderView.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsModel.h"

@interface PostsDetailHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


- (void)setValueFromModel:(PostsModel *)model;
@end
