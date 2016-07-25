//
//  MyAccountHeaderView.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "MyAccountHeaderView.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"

@implementation MyAccountHeaderView
- (void)setViewWithDic:(NSDictionary *)bigDic {
    NSDictionary *smallDic = [bigDic objectForKey:@"personalInfo"];
    [self.bigImageView setImage:[UIImage imageNamed:@"11111.png"]];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:[smallDic objectForKey:@"picUrl"]]];
    self.nameLabel.text = [smallDic objectForKey:@"name"];
    NSString *tabStr = [smallDic objectForKey:@"tabs"];
    if (![tabStr isEqual:[NSNull null]]) {
        if (tabStr.length != 0) {
            NSArray *tabArray = [tabStr componentsSeparatedByString:@"[tab]"];
            if (tabArray.count == 3) {
                self.tabOneLabel.text = [tabArray firstObject];
                self.tabTwoLabel.text = [tabArray objectAtIndex:1];
                self.tabThreeLabel.text = [tabArray lastObject];
            } else if (tabArray.count == 2) {
                self.tabOneLabel.text = [tabArray firstObject];
                self.tabTwoLabel.text = [tabArray objectAtIndex:1];
                self.tabThreeLabel.backgroundColor = [UIColor clearColor];
            } else if (tabArray.count == 1) {
                self.tabOneLabel.text = [tabArray firstObject];
                self.tabTwoLabel.backgroundColor = [UIColor clearColor];
                self.tabThreeLabel.backgroundColor = [UIColor clearColor];
            }
            [self.bigImageView addSubview:self.tabOneLabel];
            [self.bigImageView addSubview:self.tabTwoLabel];
            [self.bigImageView addSubview:self.tabThreeLabel];
        } else {
            self.tabOneLabel.backgroundColor = [UIColor clearColor];
            self.tabTwoLabel.backgroundColor = [UIColor clearColor];
            self.tabThreeLabel.backgroundColor = [UIColor clearColor];
        }
        
    }
    
    [self.bigImageView addSubview:self.nameLabel];
    
    [self.bigImageView addSubview:self.headerImageView];
    
    NSString *string = [smallDic objectForKey:@"content"];
    if (![string isEqual:[NSNull null]]) {
        if (string.length == 0) {
            self.signLabel.text = @"还没有签名...";
        }
        self.signLabel.text = [smallDic objectForKey:@"content"];
    } else {
        self.signLabel.text = @"还没有签名...";
    }
    
    if ([[smallDic objectForKey:@"sex"] intValue] == 0) {
        [self.sexImageView setImage:[UIImage imageNamed:@"girl.png"]];
    } else {
        [self.sexImageView setImage:[UIImage imageNamed:@"boy.png"]];
    }
    
    //富文本
    NSArray *array = @[@"动态",@"关注",@"粉丝"];
    NSString *trendsStr = [[array firstObject] stringByAppendingString:[[bigDic objectForKey:@"feedCount"] stringValue]];
    NSMutableAttributedString *attTrends = [[NSMutableAttributedString alloc]initWithString:trendsStr];
    [attTrends addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    NSString *focusStr = [[array objectAtIndex:1] stringByAppendingString:[[bigDic objectForKey:@"followCount"] stringValue]];
    NSMutableAttributedString *attFocus = [[NSMutableAttributedString alloc]initWithString:focusStr];
    [attFocus addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    NSString *fansStr = [[array lastObject] stringByAppendingString:[[bigDic objectForKey:@"fansCount"] stringValue]];
    NSMutableAttributedString *attrFans = [[NSMutableAttributedString alloc]initWithString:fansStr];
    [attrFans addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    [self.TrendsNumButton setAttributedTitle:attTrends forState:UIControlStateNormal];
    [self.FocusNumButton setAttributedTitle:attFocus forState:UIControlStateNormal];
    [self.FansNumButton setAttributedTitle:attrFans forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
