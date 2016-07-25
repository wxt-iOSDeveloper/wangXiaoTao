//
//  KeyboardTextView.m
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "KeyboardTextView.h"


@implementation KeyboardTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化textView并且放在当前View上(封装)
        [self initWithTextViewWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
    }
    return self;
}

#pragma mark -- 封装textView
- (void)initWithTextViewWithFrame:(CGRect)frame {
    self.textView = [[UITextView alloc] initWithFrame:frame];
    //遵循代理方法
    self.textView.delegate = self;
    //设置背景色
    self.textView.backgroundColor = [UIColor lightGrayColor];
    //键盘上的按钮改为send 发送
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.textView];
}

#pragma mark -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //点击键盘上的发送键(原换行按钮)
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(keyboardView:)]) {
            [self.delegate keyboardView:textView];
        }
    }
    return YES;
}

//输入框发生变化会立马执行的方法
- (void)textViewDidChange:(UITextView *)textView {
    if (self.isChange) {
        return;
    }
    //输入框的内容发生变化我们要根据变化来修改输入框的大小
    NSString *str = textView.text;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGSize size = [str sizeWithAttributes:dic];
    //把textView的宽度取出
    CGFloat width = self.textView.frame.size.width;
    
    if (size.width > width) {
        //如果输入的字符串大于本身的宽 就进行高度调整
        self.isChange = YES;//用来记录frame是否被调整过
        CGRect keyFrame = self.frame;
        keyFrame.size.height += 22;
        keyFrame.origin.y -= 22;//向上移动
        self.frame = keyFrame;
        //更改textView的大小
        CGRect textFrame = self.textView.frame;
        textFrame.size.height += 22;
        self.textView.frame = textFrame;
    }
//    int i = size.width / width;
//    CGRect keyFrame = CGRectMake(self.frame.origin.x, kDeviceHeight - 44 - i * 22, kDeviceWidth, 44 + i * 22);
//    self.frame = keyFrame;
//    self.textView.frame.size.height =
}


@end
