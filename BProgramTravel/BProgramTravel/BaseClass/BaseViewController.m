//
//  BaseViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark -- 显示文字提醒的loading
- (void)showProgressHUDWithString:(NSString *)title {
    if (title.length == 0) {
        self.HUD.labelText = nil;
    } else {
        self.HUD.labelText = title;
    }
    //调用第三方显示loading
    [self.HUD show:YES];
}

#pragma mark -- 隐藏
- (void)hideProgressHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];//移除,释放HUD对象
        self.HUD = nil;//指针置为nil,防止后面再调用崩溃
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
