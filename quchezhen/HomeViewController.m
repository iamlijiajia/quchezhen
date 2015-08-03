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

#define Tag_ImageView       1000
#define Tag_IntroLabel      1001

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)]; //更改header高度
    self.tableView.sectionHeaderHeight = 2;
    self.tableView.sectionFooterHeight = 2;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"routeGroup" ofType:@"plist"];
    self.introArray = [NSArray arrayWithContentsOfFile:path];
    
    UIBarButtonItem *meButton = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(openMe:)];
    self.navigationItem.rightBarButtonItem = meButton;

//    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
//    self.navigationItem.leftBarButtonItem = menuButton;
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

//- (void)openMenu:(id)sender
//{
//    
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[self.fetchedResultsController sections] count];
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"feedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.layer.cornerRadius = 5; //设置圆角
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];
        imgView.tag = Tag_ImageView;
        [cell.contentView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.tableView.frame.size.width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = Tag_IntroLabel;
        [cell.contentView addSubview:label];
    }
    
    cell.clipsToBounds=YES;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.introArray.count <= indexPath.section)
    {
        return;
    }
    
    NSDictionary *dic = [self.introArray objectAtIndex:indexPath.section];
    NSString *imgName = [dic objectForKey:@"baseIntroThumb"];
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:Tag_ImageView];
    imgView.image = img;
    
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:Tag_IntroLabel];
    label.text = [dic objectForKey:@"intro"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.introArray objectAtIndex:indexPath.section];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithDictionary:dic];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
