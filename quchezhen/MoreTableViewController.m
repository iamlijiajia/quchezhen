//
//  MoreTableViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/8/24.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "MoreTableViewController.h"
#import "UIView+Utilities.h"
#import "AboutViewController.h"
#import <BmobSDK/Bmob.h>
#import "WBAlertView.h"
#import "config.h"
#import "UIAlertView+Blocks.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    UIView *headerbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    self.tableView.tableHeaderView = headerbg;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            return 2;
            
        case 1:
            return 1;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
    
//    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"string-pic-nextpage@3x.png"]];
//    icon.frame = CGRectMake(self.tableView.width - 40, 10, 40, 40);
//    [cell addSubview:icon];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.left = 15;
    cell.textLabel.textColor = RGB_Color(51.0, 51.0, 51.0);
    
//    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.view.width, 40)];
//    cellLabel.backgroundColor = [UIColor clearColor];
//    cellLabel.font = [UIFont systemFontOfSize:14];
//    cellLabel.text = [NSString stringWithFormat:@"共 %d 晚" , 1];
//    [cell addSubview:cellLabel];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"客服电话";
                    break;
                case 1:
                    cell.textLabel.text = @"关于";
                    break;
                default:
                    break;
            }
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = @"退出";
            break;
        }
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
//                    cell.textLabel.text = @"客服电话";
                    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
                    RIButtonItem *call = [RIButtonItem itemWithLabel:@"拨打" action:^{
                        NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", KServiceTel]];
                        [[UIApplication sharedApplication] openURL:phoneNumberURL];
                    }];
                    
                    [UIAlertView alertWithTitle:nil message:KServiceTel cancelButtonItem:cancel otherButtonItems:call , nil];
                }
                    break;
                case 1:
                {
                    AboutViewController *aboutVC = [[AboutViewController alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        }
            
        case 1:
        {
            [WBAlertView alertWithTitle:nil message:@"确定退出当前账号？" cancel:^{
                
            } complete:^{
                [BmobUser logout];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
            break;
        }
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
