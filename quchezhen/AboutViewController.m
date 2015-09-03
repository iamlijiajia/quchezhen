//
//  AboutViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/8/18.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "AboutViewController.h"
#import "UIView+Utilities.h"
#import "config.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_about.png"]];
    logoView.frame = CGRectMake(110, KTopOffset + 61, 100, 100);
    [self.view addSubview:logoView];
    
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, logoView.bottom + 28, self.view.width, 24)];
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont systemFontOfSize:20];
    version.textColor = RGB_Color(155.0, 155.0, 155.0);
    version.text = kKeyAppVersionStr;
    [self.view addSubview:version];
    
    
    UILabel *copyrightEn = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 20)];
    copyrightEn.textAlignment = NSTextAlignmentCenter;
    copyrightEn.font = [UIFont systemFontOfSize:12];
    copyrightEn.text = @"Copyright @2015-2019";
    [self.view addSubview:copyrightEn];
    
    UILabel *copyrightCh = [[UILabel alloc] initWithFrame:CGRectMake(20, 430, 280, 20)];
    copyrightCh.font = [UIFont systemFontOfSize:12];
    copyrightCh.textAlignment = NSTextAlignmentCenter;
    copyrightCh.text = @"北京趣车阵汽车技术服务有限公司";
    [self.view addSubview:copyrightCh];
    
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(20, 450, 280, 20)];
    tel.font = [UIFont systemFontOfSize:12];
    tel.textAlignment = NSTextAlignmentCenter;
    tel.text = [NSString stringWithFormat:@"客服电话: %@" , KServiceTel];
    [self.view addSubview:tel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
