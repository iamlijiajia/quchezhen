//
//  AboutViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/8/18.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于";

    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_bg.png"]];
    bg.frame = self.view.frame;
    [self.view addSubview:bg];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.frame = CGRectMake(80, 120, 160, 80);
    [self.view addSubview:logoView];
    
    UILabel *copyrightEn = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 30)];
    copyrightEn.textAlignment = NSTextAlignmentCenter;
    copyrightEn.font = [UIFont systemFontOfSize:12];
    copyrightEn.text = @"Copyright @2015-2019";
    [self.view addSubview:copyrightEn];
    
    UILabel *copyrightCh = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 280, 30)];
    copyrightCh.font = [UIFont systemFontOfSize:12];
    copyrightCh.textAlignment = NSTextAlignmentCenter;
    copyrightCh.text = @"北京趣车阵汽车技术服务有限公司";
    [self.view addSubview:copyrightCh];
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
