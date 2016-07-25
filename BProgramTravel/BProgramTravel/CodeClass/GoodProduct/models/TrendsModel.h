//
//  TrendsModel.h
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendsModel : NSObject

//用户信息
@property (nonatomic, strong) NSDictionary *author;
//用户发表的图片
@property (nonatomic, strong) NSArray *pictureList;

@property (nonatomic, strong) NSNumber *praiseCount;//赞数量
@property (nonatomic, strong) NSNumber *replyCount;//评论数量
@property (nonatomic, strong) NSNumber *praiseId;//记录是否被赞过

//发表内容以及位置信息
@property (nonatomic, strong) NSDictionary *feed;

//是否关注
@property (nonatomic, strong) NSNumber *relationType;

@end
