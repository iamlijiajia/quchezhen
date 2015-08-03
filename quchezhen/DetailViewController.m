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


@interface DetailViewController ()
{
    UIScrollView * tUIScrollView;
    IntroPhotoView *introsView;
}

@end

@implementation DetailViewController

- (id)initWithDictionary:(NSDictionary *)routeDic
{
    self = [super init];
    if (self)
    {
        _detailrouteDic = routeDic;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [_detailrouteDic objectForKey:@"name"];
    
    
    float width = self.view.frame.size.width;
    
//    UIImage *image1 = [UIImage imageNamed:@"feedImgA0.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"feedImgB0.jpg"];
//    UIImage *image3 = [UIImage imageNamed:@"feedImgC0.jpg"];
    
    float height = 220;//image1.size.height * self.view.frame.size.width/image1.size.width;
//    float navHeight = 64;//self.navigationController.navigationBar.frame.size.height;
    
    NSArray *imageNameArray = [_detailrouteDic objectForKey:@"introImages"];
    introsView = [[IntroPhotoView alloc] initWithImageNames:imageNameArray andFrame:CGRectMake(0, 0, width, height)];
    introsView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:introsView];
    
    UIImage *routeImage = [UIImage imageNamed:@"temp2.jpg"];
    NSInteger routeImageH = routeImage.size.height;
    UIImageView *detailRoute = [[UIImageView alloc] initWithFrame:CGRectMake(0, height+2, routeImage.size.width, routeImageH + height+2)];
    detailRoute.contentMode = UIViewContentModeScaleToFill;
    detailRoute.image = routeImage;
    UIScrollView *detailRouteScrollView = [[UIScrollView alloc] init];
    detailRouteScrollView.backgroundColor = [UIColor clearColor];
    detailRouteScrollView.pagingEnabled = NO;
    detailRouteScrollView.clipsToBounds = YES;
    detailRouteScrollView.showsVerticalScrollIndicator = NO;
    detailRouteScrollView.showsHorizontalScrollIndicator = YES;
    
    detailRouteScrollView.frame = CGRectMake(0, 0, width, self.view.frame.size.height);
    detailRouteScrollView.contentSize = CGSizeMake(width,routeImageH + height + 2);
    
    [detailRouteScrollView addSubview:detailRoute];
    [self.view addSubview:detailRouteScrollView];
    
    [detailRouteScrollView addSubview:introsView];
    
    UIButton *beginRoute = [UIButton buttonWithType:UIButtonTypeCustom];
    [beginRoute setTitle:@"开始行程" forState:UIControlStateNormal];
    [beginRoute setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    beginRoute.backgroundColor = [UIColor redColor];
    beginRoute.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 60, 100, 40);
    [beginRoute addTarget:self action:@selector(beginRouteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginRoute];
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
    BookRoomViewController *bookRoomVC = [[BookRoomViewController alloc] init];
    bookRoomVC.beginDateString = dateString;
    bookRoomVC.beginDate = date;
    bookRoomVC.detailrouteDic = self.detailrouteDic;
    
    [self.navigationController pushViewController:bookRoomVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
