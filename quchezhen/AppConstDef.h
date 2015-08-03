//
//  AppConstDef.h
//  TuWan
//
//  Created by lijiajia on 13-7-1.
//  Copyright (c) 2013年 lijiajia. All rights reserved.
//

#ifndef TuWan_AppConstDef_h
#define TuWan_AppConstDef_h

#pragma mark - Constant

#define kAppKey                 @"1661733523"
#define kAppSecret              @"c1565f2402f4289fa053427c429e0ad2"
#define kAppRedirectURI         @"http://weibo.com/u/3547520555"

#define KHTTP_GET_Method        @"GET"
#define KHTTP_POST_Method       @"POST"

#pragma mark - Dictionary Key

#define KExpirationDate         @"ExpirationDate"
#define Krefresh_token          @"refresh_token"
#define KSinaWeiboAuthData      @"SinaWeiboAuthData"

#define KScreen_name            @"screen_name"

#pragma mark - URL param key

#define KAccessToken            @"access_token"
#define KSource                 @"source"
#define KUid                    @"uid"
#define KSince_Id               @"since_id"
#define KMax_Id                 @"max_id"
#define KFeature                @"feature"
#define KBaseApp                @"base_app"
#define KStatus_Id              @"id"
#define KId                     @"id"
#define KStatus                 @"status"
#define KPic                    @"pic"
#define KAnnotations            @"annotations"
#define KIs_comment             @"is_comment"
#define KComment                @"comment"
#define KComment_ori            @"comment_ori"
#define KYes                    @"1"
#define KCid                    @"cid"
#define KCount                  @"count"

#pragma mark - URL param value

#define KFeature_Photo          @"2"
#define KTimeline_Page_Count    @"30"
#define KTimelinePageCount_Int  30

#pragma mark - Path

#define KHomePngPath            @"home.png"
#define KBrowsePngPath          @"browse.png"
#define KPublicPngPath          @"public.png"
#define KMessagePngPath         @"message.png"
#define KPersonPngPath          @"person.png"


#pragma mark - Name

#define KHomeTabName            @"Home"
#define KBrowseTabName          @"Browse"
#define KPublicTabName          @"Public"
#define KMessageTabName         @"Message"
#define KPersonTabName          @"Person"

#define KLogninName             @"Login"
#define KLogoutName             @"Logout"

#pragma mark - URL

#define KBaseURLString              @"https://api.weibo.com/2/"
#define KHomeTimeLineUrl            @"statuses/home_timeline.json"
#define KFriendsTimeLineUrl         @"statuses/friends_timeline.json"
#define KPublicTimeLineUrl          @"statuses/public_timeline.json"
#define KUserTimeLineUrl            @"statuses/user_timeline.json"
#define KMentionsUrl                @"statuses/mentions.json"
#define KUnreadCountUrl             @"remind/unread_count.json"
#define KUserInfoUrl                @"users/show.json"

#define KRepostStatusUrl            @"statuses/repost.json"
#define KCommentsShowUrl            @"comments/show.json"
#define KCommentsReplyUrl           @"comments/reply.json"
#define KStatusUploadWithPicUrl     @"statuses/upload.json"

#pragma mark - parse key

#define KStatuses                   @"statuses"


#pragma mark - cache file name

#define KTimeLineCacheFileName      @"TimeLineCache.txt"
#define KUserInfoCacheFileName      @"UserInfoCache.txt"

#pragma mark - Error Code

#define KUserAccountError           -10001
#define KRequestWithoutParam        -20001


#pragma mark - Error Message

#define KWithoutUserName            @"用户名不能为空"
#define KStatusUploadWithoutPic     @"图片不能为空"
#define KWithoutEnoughData          @"数据填充不完整"
#define KCodeError                  @"程序错误"


#endif
