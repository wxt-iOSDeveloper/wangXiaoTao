//
//  LoginViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "LoginViewController.h"
#import "TrendsViewController.h"
#import "PartnerViewController.h"
#import "ActivityViewController.h"
#import "MessageViewController.h"
#import "MyAccountViewController.h"
#import <CoreLocation/CoreLocation.h>
//引入第三方登录总框架
#import <ShareSDK/ShareSDK.h>

@interface LoginViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;//定位管理类
//负责地理编码 将定位得到的经纬度转化为地理位置 传到约伴界面显示出来
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) PartnerViewController *partnerVC;
@end

@implementation LoginViewController
- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //若沙盒中存储有id 证明已经登录过 直接开始定位 跳转界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"userId"]) {
        [self openLocation];
    }
}

- (IBAction)qqLogin:(UIButton *)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSLog(@"----%@",user.credential);
            [self loginButtonAction];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)sinaLogin:(UIButton *)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            //登录成功
            NSLog(@"----%@",user);
            [self loginButtonAction];
        } else {
            NSLog(@"%@", error);
        }
    }];

}


- (void)exitLogin {
    [self qq];
    [self sina];
    //退出登录 删除沙盒中数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userId"];
    [userDefaults removeObjectForKey:@"sToken"];
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"picUrl"];
    [userDefaults synchronize];
}

- (void)qq {
    NSLog(@"111");
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
}
- (void)sina {
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
}

//点击登录
- (void)loginButtonAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"374562672199584" forKey:@"userId"];
    [userDefaults setObject:@"376025543918512" forKey:@"sToken"];
    [userDefaults setObject:@"狂奔de蜗牛" forKey:@"name"];
    [userDefaults setObject:@"http://apphead.zaiwai.com/37456267219958414628717368511928619670.jpg" forKey:@"picUrl"];
    //同步到沙盒
    [userDefaults synchronize];
    //定位
    [self openLocation];
}

//要求用户进行定位
- (void)openLocation {
    //创建一个定位管理对象
    self.locationManager = [[CLLocationManager alloc] init];
    //判断手机设置中的定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"手机设置中的定位服务没开启");
        //跳转手机中的设置界面  内部封装有跳转页面的代码
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        return;//直接结束代码,因为需要用户手动支持定位
    }
    //在这 手机支持定位
    //判断用户的授权状态
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //请求用户授权
        //请求当程序运行的时候允许定位这种授权
        [self.locationManager requestWhenInUseAuthorization];
    }
    //开始定位(定位很耗电,越精确 越耗电)
    //(1)设置定位的精确度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置最小的更新距离,超过了100米,就再次定位
    self.locationManager.distanceFilter = 100;
    //关键点 设置代理
    self.locationManager.delegate = self;
    //开启定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark --- 定位代理方法
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //先关闭定位
    [self.locationManager stopUpdatingLocation];
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败"preferredStyle:UIAlertControllerStyleAlert];
    //  取消事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:nil];
    //  确定事件
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"重新定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //重新开始定位
        [self.locationManager startUpdatingLocation];
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    //  弹出警示框
    [self presentViewController:control animated:YES completion:nil];
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //CLLocation 即为定位的位置
    CLLocation *location = [locations firstObject];
    //拿到经纬度结构体 传值到其他界面 用来请求附近的数据
    CLLocationCoordinate2D coordinate = location.coordinate;
    //关闭定位
    [self.locationManager stopUpdatingLocation];
    //定位成功后才能跳转界面
    TrendsViewController *trendsVC = [[TrendsViewController alloc] init];
    UINavigationController *NCTrends = [[UINavigationController alloc] initWithRootViewController:trendsVC];
    //传值
    trendsVC.lat = coordinate.latitude;
    trendsVC.lng = coordinate.longitude;
    
    self.partnerVC = [[PartnerViewController alloc] init];
    [self getLocationFromCoordinate:coordinate];//调用方法 获取地理位置
    NSLog(@"++++++lat:%f,lng:%f",coordinate.latitude,coordinate.longitude);
    //传值
    
    _partnerVC.lat = coordinate.latitude;
    _partnerVC.lng = coordinate.longitude;
    
//    MessageViewController *messageVC = [[MessageViewController alloc] init];
//    UINavigationController *NCMessage = [[UINavigationController alloc] initWithRootViewController:messageVC];
    MyAccountViewController *myVC = [[MyAccountViewController alloc] init];
    UINavigationController *NCMyVC = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //重要属性!! 给标签视图控制器添加所要管理的视图控制器(VC或者NC)
    tabBarController.viewControllers = @[NCTrends,self.partnerVC,NCMyVC];
    tabBarController.tabBar.translucent = NO;//关闭毛玻璃效果
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:74 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:1];
    tabBarController.selectedIndex = 0;
    [self presentViewController:tabBarController animated:YES completion:nil];
}

//反向编码 根据经纬度得到地理位置
- (void)getLocationFromCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //反向地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       //获取地标
        CLPlacemark *placrMark = [placemarks firstObject];
        //所有位置信息都在地标的一个属性字典
        NSDictionary *addressDic = placrMark.addressDictionary;
        //block走的比较慢 在调用此方法后面赋值的话会在还没得到位置时就走完赋值代码 因而要放在block里面赋值
        self.partnerVC.cityName = [addressDic objectForKey:@"City"];
    }];
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
