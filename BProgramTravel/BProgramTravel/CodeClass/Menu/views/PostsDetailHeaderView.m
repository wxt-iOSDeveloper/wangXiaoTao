//
//  PostsDetailHeaderView.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PostsDetailHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"

@implementation PostsDetailHeaderView


- (void)setValueFromModel:(PostsModel *)model {
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[model.author objectForKey:@"picUrl"]]];
    self.nameLabel.text = [model.author objectForKey:@"name"];
    if ([[model.author objectForKey:@"sex"] intValue] == 0) {
        [self.sexImageView setImage:[UIImage imageNamed:@"girl.png"]];
    } else {
        [self.sexImageView setImage:[UIImage imageNamed:@"boy.png"]];
    }
    self.timeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.feed objectForKey:@"addTime"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
