//
//  BookRoomViewCell.m
//  quchezhen
//
//  Created by lijiajia on 15/7/17.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "BookRoomViewCell.h"
#import "NSDate+WQCalendarLogic.h"
#import "CalendarHomeViewController.h"
#import "HotelRoomCard.h"

@interface BookRoomViewCell ()<HotelRoomCardDelegate>

@property (strong , nonatomic) UILabel *checkinDateLabel;
@property (strong , nonatomic) UILabel *daysCount;
@property (strong , nonatomic) UILabel *roomsCountLabel;
@property (strong , nonatomic) NSMutableArray *hotelCardArray;

@end

@implementation BookRoomViewCell

- (id)initWithRoomsDictionary:(NSDictionary *)dic Date:(NSDate *)date andFrameWith:(NSInteger)width
{
    self = [super init];
    if (self)
    {
        self.orderModel = [[RoomOrderCellModel alloc] init];
        
        self.beginDate = date;
        self.endDate = [self nextDayFromDate:date];
        self.orderModel.durationDays = 1;
        self.orderModel.orderRoomInfo = Nil;
        self.hotelCardArray = [NSMutableArray arrayWithCapacity:5];
        
        self.width = width;
        self.height = 20;
        CGRect checkinButtonRect = CGRectMake(0, 0, width, self.height);
        [self createCheckinDateButtonWithFrame:checkinButtonRect];
        
        UIImage *map = [UIImage imageNamed:[dic objectForKey:@"hotelMapImage"]];
        UIImageView *mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height, width, 200)];
        mapView.image = map;
        [self addSubview:mapView];
        self.height += 200;
        
        NSArray *hotelsArray = [dic objectForKey:@"hotelInfo"];
        for (int i = 0; i < hotelsArray.count; i++)
        {
            NSDictionary *hotelInfo = [hotelsArray objectAtIndex:i];
            [self createHotelChooseCard:hotelInfo cardIndex:i];
        }
        
    }
    
    return self;
}

- (void)createCheckinDateButtonWithFrame:(CGRect)frame
{
    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:frame];
    bgImageV.backgroundColor = [UIColor yellowColor];
    [self addSubview:bgImageV];
    
    self.checkinDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , frame.size.width, frame.size.height)];
    self.checkinDateLabel.backgroundColor = [UIColor clearColor];
    self.checkinDateLabel.font = [UIFont systemFontOfSize:14];
    self.checkinDateLabel.text = [NSString stringWithFormat:@"%@--%@" , [self stringFromDate:self.beginDate] , [self stringFromDate:self.endDate]];
    [self addSubview:self.checkinDateLabel];
    
    UIButton *checkinDate = [UIButton buttonWithType:UIButtonTypeCustom];
    checkinDate.frame = self.checkinDateLabel.frame;
    [checkinDate addTarget:self action:@selector(CheckinDateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkinDate];
    
    UIButton *LessDay = [UIButton buttonWithType:UIButtonTypeCustom];
    LessDay.backgroundColor = [UIColor grayColor];
    LessDay.frame = CGRectMake(frame.size.width - 130, 0, 30, frame.size.height);
    [LessDay addTarget:self action:@selector(lessDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:LessDay];
    
    self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 90, 0 , 100, frame.size.height)];
    self.daysCount.backgroundColor = [UIColor clearColor];
    self.daysCount.font = [UIFont systemFontOfSize:14];
    self.daysCount.text = [NSString stringWithFormat:@"共 %d 晚" , 1];
    [self addSubview:self.daysCount];
    
    UIButton *oneMoreDay = [UIButton buttonWithType:UIButtonTypeCustom];
    oneMoreDay.backgroundColor = [UIColor redColor];
    oneMoreDay.frame = CGRectMake(frame.size.width - 30, 0, frame.size.width, frame.size.height);
    [self addSubview:oneMoreDay];
    [oneMoreDay addTarget:self action:@selector(oneMoreDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createHotelChooseCard:(NSDictionary *)hotelInfo cardIndex:(NSInteger)index
{
    HotelRoomCard *card = [[HotelRoomCard alloc] initWithFrame:CGRectMake(0, self.height, self.width , 40) andHotelInfo:hotelInfo];
    card.delegate = self;
    card.index = index;
    
    [self.hotelCardArray addObject:card];
    
    [self addSubview:card];
    self.height += 45;
}

- (void)CheckinDateButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate isKindOfClass:[UIViewController class]])
    {
        CalendarHomeViewController *chvc = [[CalendarHomeViewController alloc]init];
        chvc.calendartitle = @"请选择出发日期";
        [chvc setHotelToDay:365 ToDateforString:nil];
        
        __block BookRoomViewCell *selfblock = self;
        
        chvc.calendarblock = ^(CalendarDayModel *model)
        {
            selfblock.checkinDateLabel.text = [NSString stringWithFormat:@"%@ %@ 入住",[model toString],[model getWeek]];
            selfblock.beginDate = model.date;
            selfblock.endDate = [self dateSomeDays:selfblock.orderModel.durationDays LaterThan:selfblock.beginDate];
            [selfblock.delegate dateChangedOnCellIndex:selfblock.index];
            
            [((UIViewController*)selfblock.delegate).navigationController popViewControllerAnimated:YES];
        };
        
        [((UIViewController*)self.delegate).navigationController pushViewController:chvc animated:YES];
    }
    
}

- (void)lessDayButtonClicked:(id)sender
{
    if (self.orderModel.durationDays >1)
    {
        self.orderModel.durationDays--;
        self.daysCount.text = [NSString stringWithFormat:@"共 %ld 晚" , (long)self.orderModel.durationDays];
        self.endDate = [self preDayFromDate:self.endDate];
        
        if (self.delegate)
        {
            [self.delegate dateChangedOnCellIndex:self.index];
        }
    }
}

- (void)oneMoreDayButtonClicked:(id)sender
{
    self.orderModel.durationDays++;
    self.daysCount.text = [NSString stringWithFormat:@"共 %ld 晚" , (long)self.orderModel.durationDays];
    self.endDate = [self nextDayFromDate:self.endDate];
    
    if (self.delegate)
    {
        [self.delegate dateChangedOnCellIndex:self.index];
    }
}

- (void)setBeginDate:(NSDate *)beginDate
{
    if(_beginDate != beginDate)
    {
        _beginDate = beginDate;
        self.orderModel.orderCheckinDate = [self stringFromDate:self.beginDate];
        
        self.checkinDateLabel.text = [NSString stringWithFormat:@"%@--%@" , self.orderModel.orderCheckinDate , [self stringFromDate:self.endDate]];
    }
}

- (void)setEndDate:(NSDate *)endDate
{
    if (_endDate != endDate)
    {
        _endDate = endDate;
        self.orderModel.orderEndDate = [self stringFromDate:self.endDate];
        
        self.checkinDateLabel.text = [NSString stringWithFormat:@"%@--%@" , [self stringFromDate:self.beginDate] , [self stringFromDate:self.endDate]];
    }
}

- (void)cardIsSelectedWithInfo:(NSDictionary *)cardInfo CardIndex:(NSInteger)index
{
    self.orderModel.orderRoomInfo = cardInfo;
    
    for (NSInteger i = 0; i < self.hotelCardArray.count; i++)
    {
        if (i != index)
        {
            [(HotelRoomCard *)[self.hotelCardArray objectAtIndex:i] setSelected:false];
        }
    }
    
    [self roomsCountChanged];
}

- (void)roomsCountChanged
{
    for (NSInteger i=0; i < self.hotelCardArray.count; i++)
    {
        HotelRoomCard *card = [self.hotelCardArray objectAtIndex:i];
        if (card.selected)
        {
            self.orderModel.orderRoomsCount = card.roomsCount;
            self.orderModel.orderPrice = card.roomPrice;
        }
    }
    
    if (self.delegate)
    {
        [self.delegate orderChanged];
    }
}

//-----------------------------------------
//
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}



//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

- (NSDate*)nextDayFromDate:(NSDate*)date
{
    return [self dateSomeDays:1 LaterThan:date];
}

- (NSDate*)preDayFromDate:(NSDate*)date
{
    return [self dateSomeDays:-1 LaterThan:date];
}

- (NSDate*)dateSomeDays:(NSInteger)days LaterThan:(NSDate*)date
{
    NSInteger oneDay = 60*60*24;
    NSDate *laterDay = [date dateByAddingTimeInterval:oneDay * days];
    return laterDay;
}

@end
