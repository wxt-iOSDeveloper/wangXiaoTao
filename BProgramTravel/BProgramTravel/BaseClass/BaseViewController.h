//
//  BaseViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *HUD;

//隐藏对象
- (void)hideProgressHUD;
//可以显示带有文字的加载对象(默认只有小菊花)
- (void)showProgressHUDWithString:(NSString *)title;

@end
