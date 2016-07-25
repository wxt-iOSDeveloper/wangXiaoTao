//
//  PostsTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PostsTableViewCell.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"

@implementation PostsTableViewCell

- (void)setvaluesForCellWithModel:(PostsModel *)model {
    self.passModel = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[model.author objectForKey:@"picUrl"]]];
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.headerImageView addGestureRecognizer:tap];
    
    self.nameLabel.text = [model.author objectForKey:@"name"];
    self.createTimeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.feed objectForKey:@"addTime"]];
    self.contentLabel.text = [model.feed objectForKey:@"content"];
    if (model.pictureList.count != 0) {
        for (int i = 0; i < model.pictureList.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 80, 0, 70, 70)];
            NSString *imageStr = [kImageURL stringByAppendingString:[[model.pictureList objectAtIndex:i] objectForKey:@"url"]];
            [imageView setImageWithURL:[NSURL URLWithString:imageStr]];
            [self.addImageView addSubview:imageView];
        }
    }
    //有的用户没有位置信息
    //<null>是对象 判断的时候也需要用对象来判断
    if (![[model.feed objectForKey:@"location"] isEqual:[NSNull null]]) {
        self.locationLabel.text = [model.feed objectForKey:@"location"];
        [self.locationImageView setImage:[UIImage imageNamed:@"weizhi.png"]];
    }
    //展示行程日期
    //1.创建日期格式对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //2.自定义日期格式
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //3.开始转换
    NSDate *beginDate = [dateFormatter dateFromString:[model.feed objectForKey:@"beginDate"]];
    NSString *begin = [formatter stringFromDate:beginDate];
    NSString *beginTime = [[begin substringToIndex:10] stringByAppendingString:@" 至 "];
    if (![[model.feed objectForKey:@"endDate"] isEqual:[NSNull null]]) {
        NSDate *endDate = [dateFormatter dateFromString:[model.feed objectForKey:@"endDate"]];
        NSString *end = [formatter stringFromDate:endDate];
        NSString *endTime = [end substringToIndex:10];
        self.dateLabel.text = [beginTime stringByAppendingString:endTime];
    } else {
        self.dateLabel.text = [beginTime stringByAppendingString:@"待定"];
    }
}


- (void)tapAction:(UIGestureRecognizer *)sender {
    if (self.tapActionBlock) {
        self.tapActionBlock(self.passModel);
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
