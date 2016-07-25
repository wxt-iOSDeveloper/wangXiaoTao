//
//  FansAndFouceTableViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/20.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansAndFouceModel.h"

@interface FansAndFouceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UIButton *fouceButton;

@property (nonatomic, strong) FansAndFouceModel *passModel;

- (void)setValueWithModel:(FansAndFouceModel *)model;

@end
