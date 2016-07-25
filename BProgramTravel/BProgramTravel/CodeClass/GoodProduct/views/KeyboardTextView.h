//
//  KeyboardTextView.h
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
//封装键盘
//设置协议
@protocol KeyboardTextViewDelegate <NSObject>

//代理对象需要实现的方法
- (void)keyboardView:(UITextView *)aTextView;


@end


@interface KeyboardTextView : UIView<UITextViewDelegate>

//声明代理属性
@property (nonatomic, assign) id<KeyboardTextViewDelegate> delegate;
//声明属性
@property (nonatomic, strong) UITextView *textView;
//监测输入是否改变
@property (nonatomic, assign) BOOL isChange;


@end
