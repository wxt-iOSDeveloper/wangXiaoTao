//
//  PartnerViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface PartnerViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *HUD;

//接收定位后传来的经纬度
@property (nonatomic, assign) CGFloat lat;//纬度
@property (nonatomic, assign) CGFloat lng;//经度
@property (nonatomic, strong) NSString *cityName;
#pragma mark -- 显示文字提醒的loading
- (void)showProgressHUDWithString:(NSString *)title;

#pragma mark -- 隐藏
- (void)hideProgressHUD;

@end
