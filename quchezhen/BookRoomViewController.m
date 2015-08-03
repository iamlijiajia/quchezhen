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

@interface BookRoomViewController ()<VerifyHotelsOrderBarDelegate>

@property (nonatomic , strong) NSMutableArray *cellArray;
@property (strong , nonatomic) VerifyHotelsOrderBar *orderBar;

@end

@implementation BookRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"住宿安排";//[self.detailrouteDic objectForKey:@"name"];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bgImageView];
    
    float contentoffsizeHeight = 64;//self.navigationController.navigationBar.frame.size.height;
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentoffsizeHeight, self.view.frame.size.width, self.view.frame.size.height)];
    scrollview.pagingEnabled = YES;
//    scrollview.delegate = self;
    scrollview.layer.borderWidth = 0.5f;
    scrollview.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    scrollview.showsHorizontalScrollIndicator = YES;
//    scrollview.layer.cornerRadius = 2;
    [self.view addSubview:scrollview];
    
    
    self.cellArray = [NSMutableArray arrayWithCapacity:5];
    NSArray *hotelCitys = [self.detailrouteDic objectForKey:@"city_of_hotel_Info"];
    
    NSInteger height = 0;
    NSInteger oneDay = 60*60*24;
    for (NSInteger i = 0; i < hotelCitys.count; i++)
    {
        NSDictionary *hotelsinfo = [hotelCitys objectAtIndex:i];
        BookRoomViewCell *cell = [[BookRoomViewCell alloc] initWithRoomsDictionary:hotelsinfo Date:[self.beginDate dateByAddingTimeInterval:oneDay*i] andFrameWith:self.view.frame.size.width];
        cell.delegate = self;
        cell.index = i;
        cell.frame = CGRectMake(0, height, cell.width, cell.height);
        height += cell.height + 5;
        
        [self.cellArray addObject:cell];
        
        [scrollview addSubview:cell];
    }
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width , height+contentoffsizeHeight);
    
    self.orderBar = [[VerifyHotelsOrderBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    self.orderBar.delegate = self;
    [self.view addSubview:self.orderBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateChangedOnCellIndex:(NSInteger)index
{
    [self orderChanged];
    
    for (NSInteger i = index; i + 1 < self.cellArray.count; i++)
    {
        BookRoomViewCell *cell = [self.cellArray objectAtIndex:i];
        BookRoomViewCell *cellNext = [self.cellArray objectAtIndex:i + 1];
        
        NSInteger oneDay = 60*60*24;
        
        cellNext.beginDate = cell.endDate;
        cellNext.endDate = [cellNext.endDate dateByAddingTimeInterval:oneDay * cellNext.orderModel.durationDays];
    }
}

- (void)orderChanged
{
    NSInteger priceAll = 0;
    NSInteger daysAll = 0;
    NSString *checkinDate = nil;
    
    for (NSInteger i=0; i < self.cellArray.count; i++)
    {
        BookRoomViewCell *cell = [self.cellArray objectAtIndex:i];
        
        if (0 == i)
        {
            checkinDate = cell.orderModel.orderCheckinDate;
        }
        priceAll += cell.orderModel.orderPrice * cell.orderModel.orderRoomsCount * cell.orderModel.durationDays;
        daysAll += cell.orderModel.durationDays;
    }
    
    self.orderBar.price = priceAll;
    self.orderBar.daysCount = daysAll;
    self.orderBar.checkinDate = checkinDate;
}

- (void)onVerifyOrderButtonPressed
{
    OrderMessageConfirmViewController *viewController = [[OrderMessageConfirmViewController alloc] init];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i=0; i < self.cellArray.count; i++)
    {
        RoomOrderCellModel *model = ((BookRoomViewCell *)[self.cellArray objectAtIndex:i]).orderModel;
        [modelArray addObject:model];
    }
    viewController.orderModelArray = modelArray;
    
    [self.navigationController pushViewController:viewController animated:YES];
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
