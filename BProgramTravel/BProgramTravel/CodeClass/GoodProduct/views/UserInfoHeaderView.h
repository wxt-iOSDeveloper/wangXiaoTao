//
//  UserInfoHeaderView.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexImageView;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UIButton *focusButton;
@property (strong, nonatomic)  UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIButton *trendsNum;
@property (strong, nonatomic) IBOutlet UIButton *focusNum;
@property (strong, nonatomic) IBOutlet UIButton *fansNum;
@property (strong, nonatomic) IBOutlet UILabel *tabOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *tabTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *tabThreeLabel;


- (void)setViewWithDic:(NSDictionary *)bigDic;

@end
