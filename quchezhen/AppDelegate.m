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
#import "AFNetworking.h"

#import <BmobSDK/Bmob.h>
#import "BMob+SafeObject.h"
#import "BCPay.h"
#import "TipsViewController.h"
#import "config.h"

#define KWBAppKey     @"3605110094"

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
    [BCPay initWeChatPay:@"wx3c78743f5ee5d86f"];
    
    
    //微博SDK初始化
    [WeiboSDK registerApp:KWBAppKey];
    if (KDebugEnable)
    {
        [WeiboSDK enableDebugMode:YES];
    }
    
    //微信
    [WXApi registerApp:@"wx3c78743f5ee5d86f"];
    
//    //设置友盟
//    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    
    self.loginDelegateArray = [[NSMutableArray alloc] init];
    
    HomeViewController *mainController = [[HomeViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];

    [self.window setRootViewController:navigation];
    [self.window makeKeyAndVisible];
    
    int localVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"versionLocal"] intValue];
    if (localVersion < kKeyAppVersionNum)//新版本，显示引导图
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kKeyAppVersionNum] forKey:@"versionLocal"];
        TipsViewController *tipsVC = [[TipsViewController alloc] init];
        [navigation presentViewController:tipsVC animated:NO completion:nil];
    }
    
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
    return [BCPay handleOpenUrl:url]||
    [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [BCPay handleOpenUrl:url]||
    [WeiboSDK handleOpenURL:url delegate:self] ||
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
                [blockSelf getWBUserInfoWithToken:accessToken andUid:uid];
            }];
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}


//获取微博登陆用户信息
- (void)getWBUserInfoWithToken:(NSString *)token andUid:(NSString *)uid
{
    NSString *url = @"https://api.weibo.com/2/users/show.json";
//    NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",token,uid];
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:token forKey:@"access_token"];
    [paraDic setObject:uid forKey:@"uid"];
    [paraDic setObject:@"json" forKey:@"format"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicForUserInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //  记录登录用户的OpenID、Token以及过期时间
                NSString *uid = [dicForUserInfo objectForKey:@"id"];
                NSString *screen_name = [dicForUserInfo objectForKey:@"screen_name"];
                NSString *name = [dicForUserInfo objectForKey:@"name"];
                
                NSNumber *province = [dicForUserInfo objectForKey:@"province"];
                NSNumber *city = [dicForUserInfo objectForKey:@"city"];
                
                NSString *location = [dicForUserInfo objectForKey:@"location"];
                NSString *description = [dicForUserInfo objectForKey:@"description"];
                NSString *url = [dicForUserInfo objectForKey:@"url"];
                NSString *profile_image_url = [dicForUserInfo objectForKey:@"profile_image_url"];
//                NSString *domain = [dicForUserInfo objectForKey:@"domain"];
                NSString *gender = [dicForUserInfo objectForKey:@"gender"];
                
//                NSNumber *followers_count = [dicForUserInfo objectForKey:@"followers_count"];
//                NSNumber *friends_count = [dicForUserInfo objectForKey:@"friends_count"];
//                NSNumber *statuses_count = [dicForUserInfo objectForKey:@"statuses_count"];
//                NSNumber *favourites_count = [dicForUserInfo objectForKey:@"favourites_count"];
                
//                NSString *created_at = [dicForUserInfo objectForKey:@"created_at"];
                
//                NSString *allow_all_act_msg = [dicForUserInfo objectForKey:@"allow_all_act_msg"];
//                NSString *geo_enabled = [dicForUserInfo objectForKey:@"geo_enabled"];
                
//                NSString *verified = [dicForUserInfo objectForKey:@"verified"];
//                NSString *allow_all_comment = [dicForUserInfo objectForKey:@"allow_all_comment"];
                
                NSString *avatar_large = [dicForUserInfo objectForKey:@"avatar_large"];
                NSString *avatar_hd = [dicForUserInfo objectForKey:@"avatar_hd"];
                
//                NSString *verified_reason = [dicForUserInfo objectForKey:@"verified_reason"];
                
//                NSString *bi_followers_count = [dicForUserInfo objectForKey:@"bi_followers_count"];

                
                BmobUser *user = [BmobUser getCurrentUser];
                [user setSafeObject:uid forKey:@"uid"];
                [user setSafeObject:screen_name forKey:@"nickname"];
                [user setSafeObject:name forKey:@"name"];
                [user setSafeObject:province forKey:@"province"];
                [user setSafeObject:city forKey:@"city"];
                [user setSafeObject:location forKey:@"location"];
                [user setSafeObject:description forKey:@"description"];
                [user setSafeObject:url forKey:@"url"];
                [user setSafeObject:profile_image_url forKey:@"headimgurl"];
                [user setSafeObject:gender forKey:@"gender"];
                [user setSafeObject:avatar_large forKey:@"avatar_large"];
                [user setSafeObject:avatar_hd forKey:@"avatar_hd"];
                
                [user setSafeObject:KWeibo forKey:@"loginChannel"];
                [user setSafeObject:dicForUserInfo forKey:@"dicForUserInfo"];
                
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }];
            }
        });
    });
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
                NSString *openid = [dicFromWeixin objectForKey:@"openid"];
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
                    
                    [self getWXUserInfoWithToken:accessToken andOpenID:openid];
                }];
            }
        });
    });
}

//获取微信登陆用户信息
- (void)getWXUserInfoWithToken:(NSString *)token andOpenID:(NSString *)openId
{
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicFromWeixin = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //  记录登录用户的OpenID、Token以及过期时间
                NSString *openid = [dicFromWeixin objectForKey:@"openid"];
                NSString *nickname = [dicFromWeixin objectForKey:@"nickname"];
                NSNumber *sex = [dicFromWeixin objectForKey:@"sex"];
                NSString *province = [dicFromWeixin objectForKey:@"province"];
                NSString *city = [dicFromWeixin objectForKey:@"city"];
                NSString *country = [dicFromWeixin objectForKey:@"country"];
                
                NSString *headimgurl = [dicFromWeixin objectForKey:@"headimgurl"];
//                NSString *privilege = [dicFromWeixin objectForKey:@"privilege"];
                NSString *unionid = [dicFromWeixin objectForKey:@"unionid"];

                BmobUser *user = [BmobUser getCurrentUser];
                [user setSafeObject:openid forKey:@"openid"];
                [user setSafeObject:nickname forKey:@"nickname"];
                [user setSafeObject:sex forKey:@"sex"];
                [user setSafeObject:province forKey:@"province"];
                [user setSafeObject:city forKey:@"city"];
                [user setSafeObject:country forKey:@"country"];
                [user setSafeObject:headimgurl forKey:@"headimgurl"];
//                [user setSafeObject:privilege forKey:@"privilege"];
                [user setSafeObject:unionid forKey:@"unionid"];
                
                
                [user setSafeObject:KWeiXin forKey:@"loginChannel"];
                [user setSafeObject:dicFromWeixin forKey:@"dicForUserInfo"];
                
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }];
            }
        });
    });
}


@end
