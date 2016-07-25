//
//  MyAccountHeaderView.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tabOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *tabTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *tabThreeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sexImageView;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UIButton *TrendsNumButton;
@property (strong, nonatomic) IBOutlet UIButton *FocusNumButton;
@property (strong, nonatomic) IBOutlet UIButton *FansNumButton;

- (void)setViewWithDic:(NSDictionary *)bigDic;
@end
