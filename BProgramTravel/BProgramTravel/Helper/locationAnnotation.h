//
//  locationAnnotation.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//标注模型类
@interface locationAnnotation : NSObject<MKAnnotation>
//经纬度结构体
//遵循协议之后,必须要声明这三个属性
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//经纬度结构体
@property (nonatomic, copy) NSString *title, *subtitle;
@end
