//
//  SearchResultModel.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, strong) NSDictionary *nationInfo;
@property (nonatomic, strong) NSDictionary *provinceInfo;
@property (nonatomic, strong) NSDictionary *cityInfo;
@property (nonatomic, strong) NSNumber *feedCount;
@property (nonatomic, strong) NSNumber *isChina;
@end
