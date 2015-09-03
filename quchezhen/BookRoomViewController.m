//
//  BookRoomViewController.m
//  quchezhen
//
//  Created by lijiajia on 15/7/10.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "BookRoomViewController.h"
#import "VerifyHotelsOrderBar.h"
#import "OrderMessageConfirmViewController.h"
#import "UIAlertView+Blocks.h"
#import "LoginViewController.h"

@interface BookRoomViewController ()<VerifyHotelsOrderBarDelegate>

@property (nonatomic , strong) NSMutableArray *cellArray;
@property (strong , nonatomic) VerifyHotelsOrderBar *orderBar;

//@property (nonatomic , strong) NSMutableArray *hotelCitys;

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation BookRoomViewController

- (id)initWithDataModel:(RoomOrdersDataModel *)model
{
    self = [super init];
    if (self)
    {
        self.dataModel = model;
        self.cellArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.x, self.view.frame.size.width, self.view.frame.size.height - 45);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)]; //更改header高度
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 2;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"住宿安排";//[self.detailrouteDic objectForKey:@"name"];

    NSInteger oneDay = 60*60*24;
    NSInteger index = 0;
    for (BookRoomViewCellDataModel *model in self.dataModel.CitiesCellViewModelArray)
    {
        BookRoomViewCell *cell = [[BookRoomViewCell alloc] initWithDataModel:model Date:[self.beginDate dateByAddingTimeInterval:oneDay*index] andFrameWith:self.tableView.frame.size.width];
        cell.delegate = self;
        cell.index = index;
        index++;
        
        [self.cellArray addObject:cell];
    }
    
    self.orderBar = [[VerifyHotelsOrderBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    self.orderBar.delegate = self;
    [self.view addSubview:self.orderBar];
    [self orderChanged];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataModel.CitiesCellViewModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.cellArray.count)
    {
        return nil;
    }
    
    BookRoomViewCell *cell = cell = [self.cellArray objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookRoomViewCell *cell = cell = [self.cellArray objectAtIndex:indexPath.section];
    return cell.height;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateChangedOnCellIndex:(NSInteger)index
{
    for (NSInteger i = index; i + 1 < self.cellArray.count; i++)
    {
        BookRoomViewCell *cell = [self.cellArray objectAtIndex:i];
        BookRoomViewCell *cellNext = [self.cellArray objectAtIndex:i + 1];
        
        NSInteger oneDay = 60*60*24;
        
        cellNext.beginDate = cell.endDate;
        cellNext.endDate = [cellNext.beginDate dateByAddingTimeInterval:oneDay * cellNext.dataModel.durationDays];
    }
    
    [self orderChanged];
}

- (void)orderChanged
{
    self.orderBar.price = self.dataModel.orderPrice;
    self.orderBar.daysCount = self.dataModel.durationDays;
    self.orderBar.checkinDate = self.dataModel.orderCheckinDate;
}

- (void)onVerifyOrderButtonPressed
{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if (!currentUser)
    {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"暂不登录"];
        RIButtonItem *login = [RIButtonItem itemWithLabel:@"去登录" action:^{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
            [UIAlertView alertWithTitle:nil message:@"当前是游客状态，登录后才能生成订单！" cancelButtonItem:cancel otherButtonItems:login , nil];
        
//        [alertToLogin show];
    }
    else
    {
        if (!self.orderBar.daysCount)
        {
            [UIAlertView alertWithDelegate:nil title:@"您还没有选择酒店" message:@"" cancel:@"确定" others:nil];
            
        }
        else
        {
            OrderMessageConfirmViewController *viewController = [[OrderMessageConfirmViewController alloc] initWithDataModel:self.dataModel];
            [self.navigationController pushViewController:viewController animated:YES];
        }
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
