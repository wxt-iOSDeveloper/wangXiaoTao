//
//  MapViewController.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

//记录点的坐标的数组
@property (nonatomic, strong) NSMutableArray *pointArray;

//接收传进来的用户名 用于请求位置坐标
@property (nonatomic, strong) NSString *ueserName;

@end
