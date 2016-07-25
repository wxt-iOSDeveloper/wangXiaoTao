//
//  TrendsDetailTableViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsDetailModel.h"


@interface TrendsDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentContentLabel;

@property (nonatomic, strong) void (^tapActionBlock)(void);

//封装给cell赋值方法
- (void)setValueWithModel:(TrendsDetailModel *)model;



@end
