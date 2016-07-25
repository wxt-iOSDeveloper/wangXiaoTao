//
//  xiaoXiTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "xiaoXiTableViewCell.h"

@implementation xiaoXiTableViewCell

- (void)setCellValueWithIndex:(NSInteger)index {
    if (index == 0) {
        [self.iconImageView setImage:[UIImage imageNamed:@"收藏32*32.png"]];
        self.titleLabel.text = @"被赞";
    } else if (index == 1) {
        [self.iconImageView setImage:[UIImage imageNamed:@"partner.png"]];
        self.titleLabel.text = @"约伴助手";

    }else if (index == 2) {
        [self.iconImageView setImage:[UIImage imageNamed:@"评论.png"]];
        self.titleLabel.text = @"评论我的";
        
    }else if (index == 3) {
        [self.iconImageView setImage:[UIImage imageNamed:@"@.png"]];
        self.titleLabel.text = @"@提到我的";
        
    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
