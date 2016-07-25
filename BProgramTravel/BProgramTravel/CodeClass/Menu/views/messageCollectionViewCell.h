//
//  messageCollectionViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageBoardModel.h"

@interface messageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexImageViw;
@property (strong, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

//给cell赋值
- (void)setCollectionCellWithModel:(messageBoardModel *)model;

@end
