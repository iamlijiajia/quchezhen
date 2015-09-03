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
#import "UIView+Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "RoomOrdersDataModel.h"
#import "config.h"
#import "OrderMessageConfirmViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView * tUIScrollView;
    IntroPhotoView *introsView;
    WBLikeButton *likeButton;
    BOOL toLoginAfterLikeButtonPressed;
    CGRect initialintroFrame;
    NSInteger defaultintroViewHeight;
}

@property (nonatomic , strong) UIImageView *detailRoute;

@end

@implementation DetailViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.fromOrderList = NO;
        toLoginAfterLikeButtonPressed = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bg];
    
    float width = self.view.frame.size.width;
    float height = 180;
    
    NSArray *introImagesArray = [self.routeObject objectForKey:@"introImages"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *discriptions = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in introImagesArray)
    {
        [images addObject:[dic objectForKey:@"imageName"]];
        [discriptions addObject:[dic objectForKey:@"discription"]];
    }
    introsView = [[IntroPhotoView alloc] initWithImageNames:images Discriptions:discriptions andFrame:CGRectMake(0, 0, width, height)];
//    introsView.backgroundColor = [UIColor redColor];
    
    UIScrollView *detailRouteScrollView = [[UIScrollView alloc] init];
    detailRouteScrollView.delegate = self;
    detailRouteScrollView.backgroundColor = [UIColor clearColor];
    detailRouteScrollView.pagingEnabled = NO;
    detailRouteScrollView.clipsToBounds = YES;
    detailRouteScrollView.showsVerticalScrollIndicator = NO;
    detailRouteScrollView.showsHorizontalScrollIndicator = YES;
    detailRouteScrollView.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    [self.view addSubview:detailRouteScrollView];
    
    [detailRouteScrollView addSubview:introsView];
    
    
    self.detailRoute = [[UIImageView alloc] initWithFrame:CGRectMake(0, height+6, width, self.view.height)];
    self.detailRoute.contentMode = UIViewContentModeScaleToFill;
    detailRouteScrollView.contentSize = CGSizeMake(width,self.view.height +180);
    [detailRouteScrollView addSubview:self.detailRoute];
    [detailRouteScrollView bringSubviewToFront:introsView];
    
    __block DetailViewController *blockSelf = self;
    NSString *routeImageName = [self.routeObject objectForKey:@"routeImage"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL(routeImageName)];
    [self.detailRoute setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSInteger routeImageH = image.size.height;
        NSInteger routeImageW = image.size.width;
        NSInteger imageVH = routeImageH * width/routeImageW;
        blockSelf.detailRoute.frame = CGRectMake(0, height+6, width, imageVH + height+6);
        detailRouteScrollView.contentSize = CGSizeMake(width,imageVH + height*2 + 60);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    
//    [BmobProFile downloadFileWithFilename:routeImageName block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
//        UIImage *routeImage = [UIImage imageWithContentsOfFile:filepath];
//        NSInteger routeImageH = routeImage.size.height;
//        NSInteger routeImageW = routeImage.size.width;
//        NSInteger imageVH = routeImageH * width/routeImageW;
//        UIImageView *detailRoute = [[UIImageView alloc] initWithFrame:CGRectMake(0, height+6, width, imageVH + height+6)];
//        detailRoute.contentMode = UIViewContentModeScaleToFill;
//        detailRoute.image = routeImage;
//        
//        detailRouteScrollView.contentSize = CGSizeMake(width,imageVH + height*2 + 60);
//        [detailRouteScrollView addSubview:detailRoute];
//        [detailRouteScrollView bringSubviewToFront:introsView];
//    } progress:^(CGFloat progress) {
//        
//    }];
    
    UIButton *beginRoute = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginRoute setBackgroundImage:[UIImage imageNamed:@"foot-btn-start-travl-default@3x.png"] forState:UIControlStateNormal];
    [beginRoute setTitleColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] forState:UIControlStateNormal];
    beginRoute.frame = CGRectMake(0, self.view.frame.size.height - 45, self.view.width, 45);
    beginRoute.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:beginRoute];
    
    if (self.fromOrderList)
    {
        [beginRoute setTitle:@"查看住宿信息" forState:UIControlStateNormal];
        [beginRoute addTarget:self action:@selector(checkOrderHotelsList:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [beginRoute setTitle:@"立即预定" forState:UIControlStateNormal];
        [beginRoute addTarget:self action:@selector(beginRouteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"topbar-btn-back-white@3x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    likeButton = [[WBLikeButton alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
    [likeButton setLikeStateImage:[UIImage imageNamed:@"topbar-btn-collection-selected@3x.png"] andUnLikeStateImage:[UIImage imageNamed:@"topbar-btn-collection-default@3x.png"]];
    likeButton.hidden = YES;
    [likeButton addTarget:self action:@selector(onLikeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self initLikeButtonState];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:likeButton];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initLikeButtonState
{
    if ([BmobUser getCurrentUser])
    {
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        [query whereKey:@"objectId" equalTo:[BmobUser getCurrentUser].objectId];
        [query whereKey:@"likes" equalTo:self.routeObject];
        
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error)
            {
                
            }
            else if (number)
            {
                likeButton.hidden = NO;
                likeButton.likeState = WBLikeStateLike;
            }
            else
            {
                likeButton.hidden = NO;
                likeButton.likeState = WBLikeStateUnLike;
            }
        }];
    }
    else
    {
        likeButton.likeState = WBLikeStateUnLike;
    }
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
    [self showNavigationBar:NO WithAnimate:NO];
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
    [self showNavigationBar:YES WithAnimate:NO];
}

- (void)showNavigationBar:(BOOL)show WithAnimate:(BOOL)animate
{
    if (show)
    {
        if (animate)
        {
            [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.shadowImage = nil;
            } completion:nil];
        }
        else
        {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.shadowImage = nil;
        }
    }
    else
    {
        if (animate)
        {
            [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_clear.png"] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"bg_clear.png"];
            } completion:nil];
        }
        else
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_clear.png"] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"bg_clear.png"];
        }
    }
    
    
}

- (void)checkOrderHotelsList:(id)sender
{
    OrderMessageConfirmViewController *VC = [[OrderMessageConfirmViewController alloc] initToCheckOrderListWithRouteObject:self.routeObject];
    [self.navigationController pushViewController:VC animated:YES];
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
        
        [selfblock.navigationController popViewControllerAnimated:NO];
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


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    
    if (offset > 0)
    {
        if (offset + 64 >= introsView.height)
        {
            introsView.top = offset - (introsView.height - 64);
        }
        else if (offset + 64 <= introsView.height)
        {
            introsView.top = 0;
            [introsView stretchOffset:offset];
        }
    }
    else
    {
        [introsView stretchOffset:offset];
    }
}



@end
