//
//  messageCollectionViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "messageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"

@implementation messageCollectionViewCell

- (void)setCollectionCellWithModel:(messageBoardModel *)model {
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[model.author objectForKey:@"picUrl"]]];
    self.senderNameLabel.text = [model.author objectForKey:@"name"];
    self.messageLabel.text = [model.nearbyLeaveWord objectForKey:@"content"];
    if ([[model.author objectForKey:@"sex"] intValue] == 0) {
        [self.sexImageViw setImage:[UIImage imageNamed:@"girl.png"]];
    } else {
        [self.sexImageViw setImage:[UIImage imageNamed:@"boy.png"]];
    }
    //计算发表时间
    self.sendTimeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.nearbyLeaveWord objectForKey:@"createTime"]];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
