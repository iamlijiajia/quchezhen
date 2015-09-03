//
//  OwnerViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/7/10.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "OwnerViewController.h"
#import "AboutViewController.h"
#import <BmobSDK/Bmob.h>
#import "ARSegmentPageController.h"
#import "HomeViewController.h"
#import "UIImage+Blur.h"
#import "UIView+Utilities.h"
#import "RFSegmentView.h"
#import "HomeTableViewRouteCell.h"
#import "MoreTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface OwnerViewController ()<RFSegmentViewDelegate>
{
    BOOL toLoginAfterLikeButtonPressed;
    UIImageView *bannerView;
    NSInteger coverHeight;
    
//    CGPoint currentOrderViewOffset;
//    CGPoint likesViewOffset;
//    CGPoint oldOrdersViewOffset;
}

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *blurImages;

@property (strong, nonatomic) NSArray *routeBmobObjectOrderListArray;
@property (strong, nonatomic) NSArray *routeBmobObjectLikesArray;
@property (strong, nonatomic) NSArray *routeBmobObjectOldOdersArray;

@property (strong , nonatomic)RFSegmentView* segmentView;

@property (strong , nonatomic)UIImageView *avatar;
@property (strong , nonatomic)UILabel *nikName;

@property (strong , nonatomic)UIButton *backButton;
@property (strong , nonatomic)UIButton *moreButton;

@end

@implementation OwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    toLoginAfterLikeButtonPressed = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bg];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.backButton setImage:[UIImage imageNamed:@"topbar-btn-back-white@3x.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(onBackBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.moreButton setImage:[UIImage imageNamed:@"topbar-btn-more-default@3x.png"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(openMore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItem = rightButton;

    bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 178)];
    bannerView.image = [UIImage imageNamed:@"user-bg-pic@3x.png"];
    bannerView.clipsToBounds = NO;
    bannerView.contentMode = UIViewContentModeScaleAspectFill;
    coverHeight = bannerView.frame.size.height;
    
    NSString *headUrl = [currentUser objectForKey:@"avatar_large"];
    if (!headUrl)
    {
        headUrl = [currentUser objectForKey:@"headimgurl"];
    }
    if (headUrl)
    {
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake((bannerView.width - 76)/2, 58, 76, 76)];
        self.avatar.layer.cornerRadius = 38;
        self.avatar.layer.borderWidth = 2;
        self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.avatar.layer.masksToBounds = YES;
        
        [self.avatar setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:nil];
        [bannerView addSubview:self.avatar];
        
        self.nikName = [[UILabel alloc] initWithFrame:CGRectMake(0, bannerView.height - 32, bannerView.width, 14)];
        self.nikName.font = [UIFont boldSystemFontOfSize:14];
        self.nikName.textColor = [UIColor colorWithRed:222.0/255.0 green:223.0/255.0 blue:224.0/255.0 alpha:1];
        self.nikName.text = [currentUser objectForKey:@"nickname"];
        self.nikName.textAlignment = NSTextAlignmentCenter;
        [bannerView addSubview:self.nikName];
    }
    
    self.segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, bannerView.bottom, bannerView.width, 48) items:@[@"喜欢的路线",@"订单记录"]];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.segmentView.delegate = self;
    [self.segmentView setCurrentIndex:self.segmentType];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIView *headerbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, bannerView.height + self.segmentView.height)];
    [headerbg addSubview:bannerView];
//    headerbg.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerbg;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 2;
    self.tableView.sectionFooterHeight = 2;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.segmentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.tableView && bannerView && self.tableView.contentOffset.y > bannerView.height - 64)
    {
        [self showNavigationBar:YES WithAnimate:NO];
    }
    else
    {
        [self showNavigationBar:NO WithAnimate:NO];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    if (toLoginAfterLikeButtonPressed)
    {
        toLoginAfterLikeButtonPressed = NO;
        BmobUser *currentUser = [BmobUser getCurrentUser];
        if (currentUser)
        {
            
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
        [self.backButton setImage:[UIImage imageNamed:@"topbar-btn-back-black@3x.png"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"topbar-btn-more-black@3x.png"] forState:UIControlStateNormal];
        
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
        [self.backButton setImage:[UIImage imageNamed:@"topbar-btn-back-white@3x.png"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"topbar-btn-more-default@3x.png"] forState:UIControlStateNormal];
        
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


- (void)onBackBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)openMore:(id)sender
{
    MoreTableViewController *moreVC = [[MoreTableViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.segmentView.currentIndex)
    {
        case 0:
            return self.routeBmobObjectLikesArray.count;

        case 1:
            return self.routeBmobObjectOrderListArray.count;
            
//        case 2:
//            return self.routeBmobObjectOldOdersArray.count;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    if (!cell)
    {
        cell  = [[HomeTableViewRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedCell"];
    }
    
    BmobObject *route = nil;
    
    switch (self.segmentView.currentIndex)
    {
        case 0:
            route = [self.routeBmobObjectLikesArray objectAtIndex:indexPath.section];
            break;
        case 1:
            route = [self.routeBmobObjectOrderListArray objectAtIndex:indexPath.section];
            break;
        default:
            break;
    }
    
    [cell configureCellwithRouteObject:route];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    BmobObject *route = nil;
    switch (self.segmentView.currentIndex)
    {
        case 0:
            route = [self.routeBmobObjectLikesArray objectAtIndex:indexPath.section];
            break;
        case 1:
            route = [self.routeBmobObjectOrderListArray objectAtIndex:indexPath.section];
            detailVC.fromOrderList = YES;
            break;
        default:
            break;
    }
    
    detailVC.routeObject = route;
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset > 0)
    {
        if (offset + 64 >= bannerView.height)
        {
            [self showNavigationBar:YES WithAnimate:NO];
            
            self.segmentView.frame = CGRectMake(0,offset+64, self.view.frame.size.width, self.segmentView.height);
        }
        else
        {
            [self showNavigationBar:NO WithAnimate:NO];
            
            self.segmentView.frame = CGRectMake(0,bannerView.height, self.view.frame.size.width, self.segmentView.height);
        }
    }
    else
    {
        bannerView.frame = CGRectMake(offset,offset, self.view.frame.size.width+ (-offset) * 2, coverHeight);
        
        if (self.avatar)
        {
            self.avatar.frame = CGRectMake((bannerView.width - 74)/2, 58, 74, 74);
        }
        
        if (self.nikName)
        {
            self.nikName.frame = CGRectMake(0, bannerView.height - 32, bannerView.width, 14);
        }
    }
}

#pragma mark RFSegmentViewDelegate

- (void)segmentViewSelectIndex:(NSInteger)index
{
    __block OwnerViewController *_blockSelf = self;
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat defaultOffset = bannerView.height - 64;
    
    switch (index)
    {
        case 0:     //喜欢的路线
            if (!self.routeBmobObjectLikesArray)
            {
                [_blockSelf.tableView clearsContextBeforeDrawing];
                
                BmobQuery *query = [BmobQuery queryWithClassName:@"Route_1_0"];
                [query whereKey:@"fans" equalTo:[BmobUser getCurrentUser]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    _blockSelf.routeBmobObjectLikesArray = objects;
                    
                    if (_blockSelf.segmentView.currentIndex == index)
                    {
                        [_blockSelf.tableView reloadData];
                        if (offset > defaultOffset)
                        {
                            _blockSelf.tableView.contentOffset =CGPointMake(0, defaultOffset);
                        }
                    }
                }];
            }
            else
            {
                [_blockSelf.tableView reloadData];
                if (offset > defaultOffset)
                {
                    _blockSelf.tableView.contentOffset =CGPointMake(0, defaultOffset);
                }
            }
            break;
            
        case 1: //订单记录
            if (!self.routeBmobObjectOrderListArray)
            {
                [_blockSelf.tableView clearsContextBeforeDrawing];
                
                BmobQuery *query = [BmobQuery queryWithClassName:@"Route_1_0"];
                [query whereKey:@"customerList" equalTo:[BmobUser getCurrentUser]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    _blockSelf.routeBmobObjectOrderListArray = objects;
                    
                    if (_blockSelf.segmentView.currentIndex == index)
                    {
                        [_blockSelf.tableView reloadData];
                        if (offset > defaultOffset)
                        {
                            _blockSelf.tableView.contentOffset =CGPointMake(0, defaultOffset);
                        }
                    }
                }];
            }
            else
            {
                [_blockSelf.tableView reloadData];
                if (offset > defaultOffset)
                {
                    _blockSelf.tableView.contentOffset =CGPointMake(0, defaultOffset);
                }
            }
            break;
        default:
            break;
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
