//
//  LoginViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/8/10.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "LoginViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/BmobUser.h>
#import "config.h"
#import "AppDelegate.h"

#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
    self.title = @"登录";
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_bg.png"]];
    bg.frame = self.view.frame;
    [self.view addSubview:bg];
    
    UIButton *weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [weibo setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    weibo.frame = CGRectMake(60, 200, 60, 60);
    [weibo addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weibo];
    
    UIButton *weixin = [UIButton buttonWithType:UIButtonTypeCustom];
    [weixin setImage:[UIImage imageNamed:@"wxPay.png"] forState:UIControlStateNormal];
    weixin.frame = CGRectMake(self.view.frame.size.width - 120, 200, 60, 60);
    [weixin addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixin];
    
    [CurrentAppDelegate setLogginDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)weiboLogin:(id)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)weixinLogin:(id)sender
{
    if ([WXApi isWXAppInstalled])
    {
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = @"0744" ;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有装微信客户端！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)loginFinishedError:(NSError *)error
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        BmobUser *currentUser = [BmobUser getCurrentUser];
        if (currentUser) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
