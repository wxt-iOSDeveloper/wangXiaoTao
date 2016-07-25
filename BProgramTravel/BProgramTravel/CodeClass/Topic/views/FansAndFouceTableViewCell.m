//
//  FansAndFouceTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/20.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "FansAndFouceTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkingManager.h"
@implementation FansAndFouceTableViewCell

- (void)setValueWithModel:(FansAndFouceModel *)model {
    self.passModel = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[model.userBasic objectForKey:@"picUrl"]]];
    self.nameLabel.text = [model.userBasic objectForKey:@"name"];
    if (![[model.userBasic objectForKey:@"content"] isEqual:[NSNull null]]) {
        self.signLabel.text = [model.userBasic objectForKey:@"content"];
    }
    if ([model.relationType intValue] == 0) {
        [self.fouceButton setImage:[UIImage imageNamed:@"jiaguanzhu.png"] forState:UIControlStateNormal];
    } else {
        [self.fouceButton setImage:[UIImage imageNamed:@"yiguanzhu.png"] forState:UIControlStateNormal];
    }
    [self.fouceButton addTarget:self action:@selector(fouceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)fouceButtonAction:(UIButton *)sender {
    if ([self.passModel.relationType intValue] == 0) {
        //没有关注 进行关注
        [NetworkingManager requestPOSTWithUrlString:kGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"followUserId":[self.passModel.userBasic objectForKey:@"userId"]} finish:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                [sender setImage:[UIImage imageNamed:@"yiguanzhu.png"] forState:UIControlStateNormal];
                self.passModel.relationType = @1;
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        //确定后取消关注
        [NetworkingManager requestPOSTWithUrlString:kCancelGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"unfollowUserId":[self.passModel.userBasic objectForKey:@"userId"]} finish:^(id responseObject) {
            NSLog(@"----%@", responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                //取消关注成功
                [sender setImage:[UIImage imageNamed:@"jiaguanzhu.png"] forState:UIControlStateNormal];
                self.passModel.relationType = @0;
            } else {
                NSLog(@"%@", [responseObject objectForKey:@"errorReason"]);
            }
        } error:^(NSError *error) {
            
        }];
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
