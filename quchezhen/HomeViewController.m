//
//  HomeViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/6/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "OwnerViewController.h"
#import "LoginViewController.h"

#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "UMSocial.h"

#import "UIImageView+BmobDownLoad.h"
#import "WBLikeButton.h"
#import "config.h"
#import "HomeTableViewRouteCell.h"

#define Tag_ImageView           1000
#define Tag_IntroLabel          2000
#define Tag_LikeNumberLabel     3000

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *routeBmobObjectArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";

    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)]; //更改header高度
    self.tableView.sectionHeaderHeight = 2;
    self.tableView.sectionFooterHeight = 4;
    
    __block HomeViewController *_blockSelf = self;
    BmobQuery *query = [BmobQuery queryWithClassName:@"Route_1_0"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _blockSelf.routeBmobObjectArray = objects;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *rightButton = nil;
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if (currentUser != nil)
    {
////        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(openMe:)];
//        rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"topbar-btn-information-default@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openMe:)];
        
//        [rightButton setTarget:self];
//        [rightButton setAction:@selector(openMe:)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"topbar-btn-information-default@3x.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openMe:) forControlEvents:UIControlEventTouchUpInside];
        rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else
    {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
    }
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openMe:(id)sender
{
    OwnerViewController *ownerVC = [[OwnerViewController alloc] init];
    [self.navigationController pushViewController:ownerVC animated:YES];
}

- (void)login:(id)sender
{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信登录" otherButtonTitles:@"微博", nil];
//    [sheet showInView:self.view];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
//    [self presentViewController:loginVC animated:YES completion:nil];
    
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.routeBmobObjectArray)
    {
        return self.routeBmobObjectArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    if (!cell)
    {
        cell  = [[HomeTableViewRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    }

    BmobObject *route = [self.routeBmobObjectArray objectAtIndex:indexPath.section];
    [cell configureCellwithRouteObject:route];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BmobObject *route = [self.routeBmobObjectArray objectAtIndex:indexPath.section];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.routeObject = route;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
