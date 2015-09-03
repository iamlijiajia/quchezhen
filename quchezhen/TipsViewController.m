//
//  TipsViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/7/13.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "TipsViewController.h"
#import "UIView+Utilities.h"

@interface TipsViewController()
{
    UIImageView *guide1;
    UIImageView *guide2;
    UIImageView *guide3;
    
    int _index;
    
    UIScrollView * tUIScrollView;
    UIButton * homeViewBtn;
}

@end
@implementation TipsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hideSystemStatusBarAnimated:NO];
    
	self.view.backgroundColor = [UIColor whiteColor];
    
	tUIScrollView = [[UIScrollView alloc] init];
	tUIScrollView.backgroundColor = [UIColor whiteColor];
	tUIScrollView.pagingEnabled = YES;
	tUIScrollView.clipsToBounds = NO;
	tUIScrollView.scrollsToTop = NO;
	tUIScrollView.showsVerticalScrollIndicator = NO;
	tUIScrollView.showsHorizontalScrollIndicator = NO;
	tUIScrollView.delegate = self;
    
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    
    tUIScrollView.frame = CGRectMake(0, 0, width, height);
    tUIScrollView.contentSize = CGSizeMake(width*3,1);
    
	[self.view addSubview:tUIScrollView];
	
	guide1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linepage1@3x.png.png"]];
    guide1.frame = CGRectMake(0, 0, width, height);
	[tUIScrollView addSubview:guide1];
	
	guide2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linepage2@3x.png.png"]];
    guide2.frame = CGRectMake(width, 0, width, height);
	[tUIScrollView addSubview:guide2];

    guide3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linepage3@3x.png.png"]];
    guide3.frame = CGRectMake(width*2, 0, width, height);
	[tUIScrollView addSubview:guide3];
    
    homeViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeViewBtn.frame = CGRectMake(width*2 + (width-106)/2.f , height -46 - 44, 106, 44);
    homeViewBtn.backgroundColor = [UIColor clearColor];
    [homeViewBtn setImage:[UIImage imageNamed:@"linkpage_btn_default@3x.png"] forState:UIControlStateNormal];
    [homeViewBtn setImage:[UIImage imageNamed:@"linkpage_btn_select@3x.png"] forState:UIControlStateHighlighted];
	[homeViewBtn addTarget:self action:@selector(homeViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 	[tUIScrollView addSubview:homeViewBtn];
}

- (void)homeViewBtnClicked:(id)sender
{
    [self showSystemStatusBarAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSystemStatusBarAnimated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone)];
}

- (void)hideSystemStatusBarAnimated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone)];
}

@end
