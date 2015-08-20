//
//  AppDelegate.h
//  quchezhen
//
//  Created by lijiajia on 15/6/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "WeiboSDK.h"
#import "WXApi.h"

@protocol LoginStateDelagete <NSObject>

- (void)loginFinishedError:(NSError *)error;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate , WeiboSDKDelegate , WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)setLogginDelegate:(id<LoginStateDelagete>)logginDelegate;

@end

