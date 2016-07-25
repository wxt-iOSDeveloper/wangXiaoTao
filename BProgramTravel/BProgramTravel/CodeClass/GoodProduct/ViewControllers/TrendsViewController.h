//
//  TrendsViewController.h
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface TrendsViewController : UIViewController

@property (nonatomic, strong) MBProgressHUD *HUD;
//接收定位后传来的经纬度
@property (nonatomic, assign) CGFloat lat;//纬度
@property (nonatomic, assign) CGFloat lng;//经度
//隐藏对象
- (void)hideProgressHUD;
//可以显示带有文字的加载对象(默认只有小菊花)
- (void)showProgressHUDWithString:(NSString *)title;

@end
