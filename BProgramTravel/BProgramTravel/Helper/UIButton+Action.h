//
//  UIButton+Action.h
//  LessonNavigation_07
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>

//记录button的点击状态
typedef NS_ENUM(NSInteger, clickStatus) {
    clickStatusNone,
    clickStatusDo
};


@interface UIButton (Action)

@property (nonatomic, assign) clickStatus clickStatus;

+ (UIButton *)setButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action;


@end
