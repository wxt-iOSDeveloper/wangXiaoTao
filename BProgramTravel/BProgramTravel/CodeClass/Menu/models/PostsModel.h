//
//  PostsModel.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostsModel : NSObject
@property (nonatomic, strong) NSDictionary *author;
@property (nonatomic, strong) NSArray *pictureList;
@property (nonatomic, strong) NSDictionary *feed;
@end
