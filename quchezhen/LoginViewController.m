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
#import <BmobSDK/Bmob.h>
#import "config.h"
#import "AppDelegate.h"
#import "UIView+Utilities.h"

#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

@interface LoginViewController ()

@property UITextField *mobilePhoneNumberTf;
@property UITextField *smsCodeTf;
@property UIButton *requestSmsCodeBtn;
@property UIButton *loginBtn;
@property NSTimer *countDownTimer;
@property unsigned secondsCountDown;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self constructView];
    
    [CurrentAppDelegate setLogginDelegate:self];
}

#pragma mark - UI构造
- (void)constructView{
    [self constructMobilePhoneNumberAndSMSCodeView];
    [self constructLoginButton];
    [self constructThirdPardLogin];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPressed:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)constructMobilePhoneNumberAndSMSCodeView{
    //添加账号框
    UIView *mobilePhoneNumberTfView = [[UIView alloc] initWithFrame:CGRectMake(15, KTopOffset + 49, 290, 47)];
    mobilePhoneNumberTfView.layer.borderColor = RGB_Color(180.0, 180.0, 180.0).CGColor;
    mobilePhoneNumberTfView.layer.borderWidth = 1;
    mobilePhoneNumberTfView.layer.cornerRadius = 2;
    self.mobilePhoneNumberTf = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 270, 47)];
    self.mobilePhoneNumberTf.placeholder = @"请输入手机号码";
    [mobilePhoneNumberTfView addSubview:self.mobilePhoneNumberTf];
    
    [self.view addSubview:mobilePhoneNumberTfView];

    UIView *smsCodeTfView = [[UIView alloc] initWithFrame:CGRectMake(15,mobilePhoneNumberTfView.bottom + 15,168,47)];
    smsCodeTfView.layer.borderColor = RGB_Color(180.0, 180.0, 180.0).CGColor;
    smsCodeTfView.layer.borderWidth = 1;
    smsCodeTfView.layer.cornerRadius = 2;
    self.smsCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(20,0,168,47)];
    self.smsCodeTf.placeholder = @"6位验证码";
    [smsCodeTfView addSubview:self.smsCodeTf];
    
    [self.view addSubview:smsCodeTfView];

    self.requestSmsCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(smsCodeTfView.right,smsCodeTfView.top , 120, 47)];
    self.requestSmsCodeBtn.layer.cornerRadius = 2;
    self.requestSmsCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.requestSmsCodeBtn setTitleColor:RGBA_Color(255.0, 255.0, 255.0, 0.87) forState:UIControlStateNormal];
    self.requestSmsCodeBtn.backgroundColor = RGB_Color(120.0, 189.0, 255.0);
    [self.requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.requestSmsCodeBtn addTarget:self action:@selector(setRequestSmsCodeBtnLogic) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.requestSmsCodeBtn];
}

-(void)constructLoginButton{
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.requestSmsCodeBtn.bottom + 15, 290, 47)];
    self.loginBtn.layer.cornerRadius = 2;
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginBtn setTitleColor:RGBA_Color(255.0, 255.0, 255.0, 0.87) forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = RGB_Color(120.0, 189.0, 255.0);
    [self.loginBtn setTitle:@"登 录 (新用户自动注册)" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(setLoginBtnLogic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}

- (void)constructThirdPardLogin
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.loginBtn.bottom + 89, self.view.frame.size.width, 14)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB_Color(187.0, 187.0, 187.0);
    label.text = @"其他方式登录";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1pd-line@3x.png"]];
    line.frame = CGRectMake((self.view.width-270)/2, label.bottom + 13, 270, 1);
    [self.view addSubview:line];
    
    
    UIButton *weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [weibo setImage:[UIImage imageNamed:@"login_weibo.png"] forState:UIControlStateNormal];
    weibo.frame = CGRectMake(80, line.bottom + 36, 50, 50);
    [weibo addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weibo];
    
    if ([WXApi isWXAppInstalled])
    {
        UIButton *weixin = [UIButton buttonWithType:UIButtonTypeCustom];
        [weixin setImage:[UIImage imageNamed:@"login_weixin.png"] forState:UIControlStateNormal];
        weixin.frame = CGRectMake(80 + 50 + 60, line.bottom + 36, 50, 50);
        [weixin addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:weixin];
    }
}

-(void)setRequestSmsCodeBtnCountDown{
    [self.requestSmsCodeBtn setEnabled:NO];
    self.requestSmsCodeBtn.backgroundColor = RGB_Color(220.0, 220.0, 220.0);
    self.secondsCountDown = 60;
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [self.countDownTimer fire];
}

-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (self.secondsCountDown == 0) {
        [self.requestSmsCodeBtn setEnabled:YES];
        self.requestSmsCodeBtn.backgroundColor = RGB_Color(120.0, 189.0, 255.0);
        [self.requestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.countDownTimer invalidate];
    } else {
        [self.requestSmsCodeBtn setTitle:[[NSNumber numberWithInt:self.secondsCountDown] description] forState:UIControlStateNormal];
        self.secondsCountDown--;
    }
}

# pragma mark - 处理逻辑

-(void)setRequestSmsCodeBtnLogic{
    
    //获取手机号
    NSString *mobilePhoneNumber = self.mobilePhoneNumberTf.text;
    
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tip show];
        }
        else
        {
            //获得smsID
            NSLog(@"sms ID：%d",number);
            //设置不可点击
            [self setRequestSmsCodeBtnCountDown];
        }
    }];
}

-(void)setLoginBtnLogic{
    //获取手机号、验证码
    NSString *mobilePhoneNumber = self.mobilePhoneNumberTf.text;
    NSString *smsCode = self.smsCodeTf.text;
    
    //该方法可以进行注册和登录两步操作，如果已经注册过了就直接进行登录
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:mobilePhoneNumber andSMSCode:smsCode block:^(BmobUser *user, NSError *error) {
        if (user)
        {
            //跳转
            [self loginFinishedError:nil];
        }
        else
        {
            NSLog(@"%@",error);
            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"验证码有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tip show];
        }
    }];
    
}



#pragma mark 第三方登陆
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


- (void)onViewPressed:(id)sender
{
    [self.mobilePhoneNumberTf resignFirstResponder];
    [self.smsCodeTf resignFirstResponder];
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
