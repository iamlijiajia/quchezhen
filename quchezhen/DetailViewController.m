//
//  DetailViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/6/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "DetailViewController.h"
#import "BookRoomViewController.h"
#import "IntroPhotoView.h"
#import "CalendarHomeViewController.h"

#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>

#import "WBLikeButton.h"
#import "UIAlertView+Blocks.h"
#import "LoginViewController.h"

#import "RoomOrdersDataModel.h"


@interface DetailViewController ()
{
    UIScrollView * tUIScrollView;
    IntroPhotoView *introsView;
    WBLikeButton *likeButton;
    BOOL toLoginAfterLikeButtonPressed;
}

@end

@implementation DetailViewController

//- (id)initWithDictionary:(NSDictionary *)routeDic
//{
//    self = [super init];
//    if (self)
//    {
//        _detailrouteDic = routeDic;
//    }
//    
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    toLoginAfterLikeButtonPressed = NO;
//    self.title = [_detailrouteDic objectForKey:@"name"];

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prev.png"] style:UIBarButtonItemStyleDone target:self action:@selector(onBackBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = left;
    
    float width = self.view.frame.size.width;
    float height = 220;
    
    NSArray *introImagesArray = [self.routeObject objectForKey:@"introImages"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *discriptions = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in introImagesArray)
    {
        [images addObject:[dic objectForKey:@"imageName"]];
        [discriptions addObject:[dic objectForKey:@"discription"]];
    }
    introsView = [[IntroPhotoView alloc] initWithImageNames:images Discriptions:discriptions andFrame:CGRectMake(0, 0, width, height)];
    introsView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIScrollView *detailRouteScrollView = [[UIScrollView alloc] init];
    detailRouteScrollView.backgroundColor = [UIColor clearColor];
    detailRouteScrollView.pagingEnabled = NO;
    detailRouteScrollView.clipsToBounds = YES;
    detailRouteScrollView.showsVerticalScrollIndicator = NO;
    detailRouteScrollView.showsHorizontalScrollIndicator = YES;
    
    detailRouteScrollView.frame = CGRectMake(0, -64, width, self.view.frame.size.height + 64);
//    detailRouteScrollView.contentSize = CGSizeMake(width,imageVH + height*2 + 2);
    
//    [detailRouteScrollView addSubview:detailRoute];
    [self.view addSubview:detailRouteScrollView];
    
    [detailRouteScrollView addSubview:introsView];
    
    
    NSString *routeImageName = [self.routeObject objectForKey:@"routeImage"];
    [BmobProFile downloadFileWithFilename:routeImageName block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
        UIImage *routeImage = [UIImage imageNamed:filepath];
        NSInteger routeImageH = routeImage.size.height;
        NSInteger routeImageW = routeImage.size.width;
        NSInteger imageVH = routeImageH * width/routeImageW;
        UIImageView *detailRoute = [[UIImageView alloc] initWithFrame:CGRectMake(0, height+2, width, imageVH + height+2)];
        detailRoute.contentMode = UIViewContentModeScaleToFill;
        detailRoute.image = routeImage;
        
        detailRouteScrollView.contentSize = CGSizeMake(width,imageVH + height*2 + 2);
        [detailRouteScrollView addSubview:detailRoute];
    } progress:^(CGFloat progress) {
        
    }];
    
    
    
    
    
    UIButton *beginRoute = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginRoute setTitle:@"开始行程" forState:UIControlStateNormal];
    [beginRoute setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    beginRoute.backgroundColor = [UIColor redColor];
    beginRoute.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 60, 100, 40);
    [beginRoute addTarget:self action:@selector(beginRouteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginRoute];
    
    
    likeButton = [[WBLikeButton alloc] initWithFrame:CGRectMake(240, 10, 40, 40)];
    likeButton.likeState = WBLikeStateUnLike;
    [likeButton setLikeStateImage:[UIImage imageNamed:@"love_heart_highlighted.png"] andUnLikeStateImage:[UIImage imageNamed:@"love_heart.png"]];
    [likeButton addTarget:self action:@selector(onLikeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(290, 10, 40, 40)];
    [share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//
    UIImageView *rightbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [rightbg addSubview:share];
    [rightbg addSubview:likeButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightbg];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)onBackBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onLikeButtonPressed:(id)sender
{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if (!currentUser)
    {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"暂不登录"];
        RIButtonItem *login = [RIButtonItem itemWithLabel:@"去登录" action:^{
            toLoginAfterLikeButtonPressed = YES;
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
        UIAlertView *alertToLogin = [UIAlertView alertWithTitle:nil message:@"当前是游客状态，登录后才能标记喜欢！" cancelButtonItem:cancel otherButtonItems:login , nil];
        
        [alertToLogin show];
    }
    else
    {
        [self likeButtonPressed];
    }
}

- (void)likeButtonPressed
{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    if (likeButton.likeState == WBLikeStateUnLike)
    {
        [likeButton setLikeState:WBLikeStateLike animated:YES];
        
        BmobRelation *relation = [[BmobRelation alloc] init];
        [relation addObject:currentUser];
        [self.routeObject addRelation:relation forKey:@"fans"];
        [self.routeObject updateInBackground];
        
        BmobRelation *relation2 = [[BmobRelation alloc] init];
        [relation2 addObject:self.routeObject];
        [currentUser addRelation:relation2 forKey:@"likes"];
        [currentUser updateInBackground];
    }
    else
    {
        [likeButton setLikeState:WBLikeStateUnLike animated:YES];
        
        BmobRelation *relation = [[BmobRelation alloc] init];
        [relation removeObject:currentUser];
        [self.routeObject addRelation:relation forKey:@"fans"];
        [self.routeObject updateInBackground];
        
        BmobRelation *relation2 = [[BmobRelation alloc] init];
        [relation2 removeObject:self.routeObject];
        [currentUser addRelation:relation2 forKey:@"likes"];
        [currentUser updateInBackground];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_clear.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"bg_clear.png"];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (toLoginAfterLikeButtonPressed)
    {
        toLoginAfterLikeButtonPressed = NO;
        BmobUser *currentUser = [BmobUser getCurrentUser];
        if (currentUser)
        {
            [self likeButtonPressed];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)beginRouteButtonClicked:(id)sender
{
        CalendarHomeViewController *chvc = [[CalendarHomeViewController alloc]init];
        
        chvc.calendartitle = @"请选择出发日期";
        
        [chvc setHotelToDay:365 ToDateforString:nil];
    
    
    __block DetailViewController *selfblock = self;
    
    
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        
//        if (model.holiday) {
//            [but setTitle:[NSString stringWithFormat:@"%@ %@ %@",[model toString],[model getWeek],model.holiday] forState:UIControlStateNormal];
//        }else{
//            [but setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
//        }
        
        [selfblock.navigationController popViewControllerAnimated:YES];
        [selfblock toBookRoomsView:[model toString] Date:[model date]];
    };
    
    [self.navigationController pushViewController:chvc animated:YES];
    
}

- (void)toBookRoomsView:(NSString *)dateString Date:(NSDate *)date
{
    RoomOrdersDataModel *model = [[RoomOrdersDataModel alloc] initWithBmobObject:self.routeObject];
    BookRoomViewController *bookRoomVC = [[BookRoomViewController alloc] initWithDataModel:model];
    bookRoomVC.beginDateString = dateString;
    bookRoomVC.beginDate = date;
    
    [self.navigationController pushViewController:bookRoomVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
