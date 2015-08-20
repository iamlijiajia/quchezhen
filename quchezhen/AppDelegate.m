//
//  AppDelegate.m
//  quchezhen
//
//  Created by lijiajia on 15/6/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "HomeViewController.h"

#import <BmobSDK/Bmob.h>
#import "BCPay.h"

#import "UMSocial.h"

#define KAppKey     @"3605110094"

#define KWBUserId           @"WB_UserId"
#define KWBAccessToken      @"WB_AccessToken"

@interface AppDelegate ()

@property (nonatomic , strong) NSMutableArray *loginDelegateArray;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //BaaS平台 Bmob 初始化
    NSString *appKey = @"e912cd71b1c65aa3f83b6df510985d12";
    [Bmob registerWithAppKey:appKey];
    
    
    //支付初始化
    [BCPay initWithAppID:@"6a0eb3d3-be4d-497c-a1b6-6dd1d6ca730e" andAppSecret:@"a94ec138-bdbf-4158-a8e9-611bdb0d82c0"];
    [BCPay initWeChatPay:@"wxf1aa465362b4c8f1"];
    
    
    //微博SDK初始化
    [WeiboSDK registerApp:KAppKey];
    [WeiboSDK enableDebugMode:YES];
    
    //微信
    [WXApi registerApp:@"wx3c78743f5ee5d86f"];
    
    //设置友盟
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    
    self.loginDelegateArray = [[NSMutableArray alloc] init];
    
    HomeViewController *mainController = [[HomeViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];

    [self.window setRootViewController:navigation];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];
}

#pragma mark -登陆回调

- (void)setLogginDelegate:(id<LoginStateDelagete>)logginDelegate
{
    if (logginDelegate)
    {
        [self.loginDelegateArray addObject:logginDelegate];
    }
}

- (void)notifyLoginFinished:(NSError *)error
{
    for (int i = 0; i < self.loginDelegateArray.count; i++)
    {
        id<LoginStateDelagete> delegate = [self.loginDelegateArray objectAtIndex:i];
        
        if (delegate)
        {
            [delegate loginFinishedError:error];
        }
    }
}

#pragma mark -微博
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if ((int)response.statusCode == 0)//成功
        {
            NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
            NSString *uid = [(WBAuthorizeResponse *)response userID];
            NSDate *expiresDate = [(WBAuthorizeResponse *)response expirationDate];
            NSLog(@"acessToken:%@",accessToken);
            NSLog(@"UserId:%@",uid);
            NSLog(@"expiresDate:%@",expiresDate);
            NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
            
            
            //通过授权信息注册登录
            __block AppDelegate *blockSelf = self;
            [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
                [blockSelf notifyLoginFinished:error];
            }];
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

# pragma mark - 微信回调
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        [self getAccessToken:code];
    }
}

-(void)getAccessToken:(NSString*)code
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
#warning 在此处需要填写你自身的appid和secretkey
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx3c78743f5ee5d86f",@"e711c1cf2141dd4a040ea0a9f5ed2451",code];
    
    __block AppDelegate *blockSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicFromWeixin = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  
                //  记录登录用户的OpenID、Token以及过期时间
                NSString *accessToken = [dicFromWeixin objectForKey:@"access_token"];
                NSString *uid = [dicFromWeixin objectForKey:@"openid"];
                NSNumber *expires_in = [dicFromWeixin objectForKey:@"expires_in"];
                NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in doubleValue]];
//                NSLog(@"acessToken:%@",accessToken);
//                NSLog(@"UserId:%@",uid);
//                NSLog(@"expiresDate:%@",expiresDate);
                NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
                
                //通过授权信息注册登录
                [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformWeiXin block:^(BmobUser *user, NSError *error) {
                    [blockSelf notifyLoginFinished:error];
                }];
            }
        });
    });
}


@end
