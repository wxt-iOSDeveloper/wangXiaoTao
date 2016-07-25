//
//  Header.h
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#ifndef Header_h
#define Header_h

//屏幕的宽度
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

#define kUserId [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
#define ksToken [[NSUserDefaults standardUserDefaults] objectForKey:@"sToken"]

//动态 热门
#define kHotURL @"http://zaiwai.qunawan.com/recommendFeedService/findRecommendCustomerFeedListBySourceUserId"

//动态 附近
#define kNearURL @"http://zaiwai.qunawan.com/feedService/findCustomerFeedListByLocation"

//动态 关注
#define kFocusURL @"http://zaiwai.qunawan.com/feedService/findCustomerFeedListForUser"

//动态 详情
#define kTrendsDetailURL @"http://zaiwai.qunawan.com/replyService/findCustomerFeedReplyListByFeedId?sToken=376025543918512"

//用户信息界面
#define kUserInfoURL @"http://zaiwai.qunawan.com/userService/findCustomerUserDetailBySourceUserIdAndTargetUserName"

//关注用户
#define kGuanzhuURL @"http://zaiwai.qunawan.com/userRelationService/followUser"
//取消关注
#define kCancelGuanzhuURL @"http://zaiwai.qunawan.com/userRelationService/unfollowUser"

//赞
#define kPraiseURL @"http://zaiwai.qunawan.com/praiseService/addPraise"

//取消赞
#define kCancelPraiseURL @"http://zaiwai.qunawan.com/praiseService/deletePraise"

//请求评论
#define kRequestCommentURL @"http://zaiwai.qunawan.com/replyService/findCustomerFeedReplyListByFeedId"

//发表评论
#define kAddCommentURL @"http://zaiwai.qunawan.com/replyService/addReply"

//用户所有帖子
#define kAllTrendsURL @"http://zaiwai.qunawan.com/feedService/findCustomerFeedListByUserName"
//用户所有约伴  type=1表示是请求约伴 =0表示请求所有帖子 默认为0
#define kAllPartnerURL @"http://zaiwai.qunawan.com/feedService/findCustomerFeedListByUserId?type=1"
//请求图片
#define kImageURL @"http://appimg.zaiwai.com"

//约伴
#define kPartnerURL @"http://zaiwai.qunawan.com/nearbyLeaveWordService/findNearbyLeaveWordList?pageSize=20"

//进入搜索界面
#define kSearchVCURL @"http://zaiwai.qunawan.com/hierarchicalTerminiService/findCustomerHotHierarchicalTermini"
//搜索关键词
#define kSearchURL @"http://zaiwai.qunawan.com/hierarchicalTerminiService/searchTerminiListByKeyWord?isFilterPoi=1"
//帖子列表
#define kPostsURL @"http://zaiwai.qunawan.com/feedService/findProvinceOrNationInviteFeedListByTerminiId"
//帖子详情
#define kPostsDetailURL @"http://zaiwai.qunawan.com/feedService/findCustomerFeedDetailByFeedId"

//我的账号
#define kMyAccountURL @"http://zaiwai.qunawan.com/userService/findCustomerUserDetailBySourceUserIdAndTargetUserName"

//所有粉丝列表
#define kAllFansURL @"http://zaiwai.qunawan.com/userRelationService/findFansCustomerUserListBySourceUserIdAndTargetUserId"
//所有关注列表
#define kAllFocusURL @"http://zaiwai.qunawan.com/userRelationService/findFollowCustomerUserListBySourceUserIdAndTargetUserId"

//退出登录
#define kExitLoginURL @"http://zaiwai.qunawan.com/pushService/deletePushServicer?sToken=376025543918512&PushServicer=%7B%22channelId%22:%223646629734513340127%22,%22osType%22:1,%22pushId%22:%22841366712104035163%22,%22userId%22:374562672199584%7D"

#endif /* Header_h */
