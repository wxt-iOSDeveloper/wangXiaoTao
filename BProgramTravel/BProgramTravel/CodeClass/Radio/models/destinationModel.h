//
//  destinationModel.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface destinationModel : NSObject

@property (nonatomic, strong) NSNumber *isChina;
@property (nonatomic, strong) NSDictionary *nationInfo;
@property (nonatomic, strong) NSDictionary *provinceInfo;
@property (nonatomic, strong) NSDictionary *cityInfo;
@property (nonatomic, strong) NSDictionary *terminiPicture;

@end
