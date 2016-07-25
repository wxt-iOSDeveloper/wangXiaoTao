//
//  TrendsDetailTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "TrendsDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"

@implementation TrendsDetailTableViewCell


- (void)setValueWithModel:(TrendsDetailModel *)model {
    [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:[model.userBasic objectForKey:@"picUrl"]]];
    self.userHeaderImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.userHeaderImageView addGestureRecognizer:tap];
    self.userNameLabel.text = [model.userBasic objectForKey:@"name"];
    self.addTimeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.reply objectForKey:@"time"]];
    self.commentContentLabel.text = [model.reply objectForKey:@"content"];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    self.tapActionBlock();
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
