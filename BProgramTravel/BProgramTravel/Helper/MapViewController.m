//
//  MapViewController.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "MapViewController.h"
#import "locationAnnotation.h"//引入标注模型
#import "NetworkingManager.h"
#import "UIButton+Action.h"
@interface MapViewController ()<MKMapViewDelegate>
{
    CLLocationManager *manager;
}
@end

@implementation MapViewController
- (NSMutableArray *)pointArray {
    if (_pointArray == nil) {
        self.pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置代理
    self.mapView.delegate = self;
    //从约伴---留言板点进来的话就直接插入大头针 点的坐标已经传递过来了
    if (self.ueserName == nil) {
        [self createAnnotationWithPoint];
    }else {
        //请求数据 得到该用户曾经去过的地方的坐标 根据这些坐标创建标注模型放在地图上
        [self requestLoactionData];
 
    }
    
    UIButton *backButton = [UIButton setButtonWithFrame:CGRectMake(20, 40, 40, 30) title:@"返回" target:self action:@selector(backButtonAction:)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor colorWithRed:84 / 255.0 green:255 / 255.0 blue:242 / 255.0 alpha:0.5];
    backButton.layer.cornerRadius = 5;
    backButton.layer.masksToBounds = YES;
    [self.mapView addSubview:backButton];
}

- (void)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//请求数据
- (void)requestLoactionData
{
    [NetworkingManager requestPOSTWithUrlString:kAllTrendsURL parDic:@{@"sToken":ksToken,@"userName":self.ueserName,@"requestUserId":kUserId} finish:^(id responseObject)
    {
        //解析数据
        NSArray *array = [responseObject objectForKey:@"customerFeedList"];
        for (NSDictionary *dic in array)
        {
            NSString *str = [[dic objectForKey:@"feed"] objectForKey:@"location"];
            //如果没有位置信息 就跳过本次循环
            if (![str isEqual:[NSNull null]])
            {
                if (str.length != 0)
                {
                    //获取经纬度
                    CGFloat longitude = [[[dic objectForKey:@"feed"] objectForKey:@"lng"] floatValue];
                    CGFloat lat = [[[dic objectForKey:@"feed"] objectForKey:@"lat"] floatValue];
                    CGPoint point = CGPointMake(longitude, lat);
                    //转化为对象类型存入数组
                    NSValue *value = [NSValue valueWithCGPoint:point];
                    [self.pointArray addObject:value];
                }
            }
        }
        NSLog(@"%@",self.pointArray);
        //请求完成 调用方法创建大头针
        [self createAnnotationWithPoint];
        
    } error:^(NSError *error) {
        
    }];
}
//数据请求完成 调用方法根据经纬度创建大头针
- (void)createAnnotationWithPoint {
    for (NSValue *value in self.pointArray) {
        CGPoint point = [value CGPointValue];
        NSLog(@"%f,%f", point.x,point.y);
        //注意经纬度
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(point.y, point.x);
        locationAnnotation *ann = [[locationAnnotation alloc] init];
        ann.coordinate = coordinate;
        ann.title = @"haha";
        ann.subtitle = @"heihei";
        [self.mapView addAnnotation:ann];//添加大头针
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 200000, 200000)];//MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000); 该函数能够创建一个MKCoordinateRegion结构体，第一个参数是一个CLLocationCoordinate2D结构指定了目标区域的中心点，第二个是目标区域南北的跨度单位是米，第三个是目标区域东西的跨度单位是米。后两个参数的调整会影响地图缩放。
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    //大头针 系统在应用的时候也是类似cell的重用机制
    //标准做法
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //1.定义静态标识符
        static NSString *identifier = @"view";
        //2.去重用队列中取出大头针视图
        MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //3.判读是否可用
        if (view == nil) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        //给view大头针赋值
        view.annotation = annotation;
        //设置大头针颜色
        view.pinTintColor = [UIColor greenColor];
        //是否从天而降
        view.animatesDrop = YES;
        return view;
    }
    return nil;

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
