//
//  BookRoomViewCell.m
//  quchezhen
//
//  Created by lijiajia on 15/7/17.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "BookRoomViewCell.h"
#import "CalendarHomeViewController.h"
#import "HotelCard.h"
#import "UIImageView+BmobDownLoad.h"
#import "UIImageView+AFNetworking.h"
#import "config.h"

@interface BookRoomViewCell ()<HotelCardDelegate>

@property (strong , nonatomic) UILabel *checkinDateLabel;
@property (strong , nonatomic) UILabel *daysCount;
@property (strong , nonatomic) UILabel *roomsCountLabel;
@property (strong , nonatomic) NSMutableArray *hotelCardArray;

@end

@implementation BookRoomViewCell

- (id)initWithDataModel:(BookRoomViewCellDataModel *)dataModel Date:(NSDate *)date andFrameWith:(NSInteger)width
{
    self = [super init];
    if (self)
    {
        self.dataModel = dataModel;
        
        self.beginDate = date;
        self.endDate = [self nextDayFromDate:date];
        self.dataModel.durationDays = 1;
        self.dataModel.orderHotelInfo = Nil;
        self.hotelCardArray = [NSMutableArray arrayWithCapacity:5];
        
        self.width = width;
        self.height = 32;
        CGRect checkinButtonRect = CGRectMake(0, 0, width, self.height);
        [self createCheckinDateButtonWithFrame:checkinButtonRect];
        
        UIImageView *mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height, width, 178)];
        [mapView setImageWithURL:URL(dataModel.mapName)];
        
        
//        UIImageView *mapView = [[UIImageView alloc] initWithDefaultImage:nil NewImageName:dataModel.mapName andFrame:CGRectMake(0, self.height, width, 178)];
        
//        mapView.image = map;
        [self addSubview:mapView];
        self.height += 178;

        NSInteger i = 0;
        for (HotelCardDataModel *model in self.dataModel.hotelCardDataModels)
        {
            [self createHotelChooseCard:model cardIndex:i];
            i++;
        }
    }
    
    return self;
}

- (void)createCheckinDateButtonWithFrame:(CGRect)frame
{
    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:frame];
    bgImageV.image = [UIImage imageNamed:@"start-travl-bg-date-default@3x.png"];
    [self addSubview:bgImageV];
    
    self.checkinDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 0 , frame.size.width - 9, frame.size.height)];
    self.checkinDateLabel.backgroundColor = [UIColor clearColor];
    self.checkinDateLabel.font = [UIFont systemFontOfSize:14];
    self.checkinDateLabel.text = [NSString stringWithFormat:@"%@ —— %@" , [self stringFromDate:self.beginDate] , [self stringFromDate:self.endDate]];
    [self addSubview:self.checkinDateLabel];
    
    UIButton *checkinDate = [UIButton buttonWithType:UIButtonTypeCustom];
    checkinDate.frame = self.checkinDateLabel.frame;
    [checkinDate addTarget:self action:@selector(CheckinDateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkinDate];
    
    UIButton *LessDay = [UIButton buttonWithType:UIButtonTypeCustom];
    LessDay.backgroundColor = [UIColor clearColor];
    [LessDay setImage:[UIImage imageNamed:@"less.png"] forState:UIControlStateNormal];
    LessDay.frame = CGRectMake(frame.size.width - 120, 2, 28, 28);
    LessDay.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    [LessDay addTarget:self action:@selector(lessDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:LessDay];
    
    self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 85, 0 , 100, frame.size.height)];
    self.daysCount.backgroundColor = [UIColor clearColor];
    self.daysCount.font = [UIFont systemFontOfSize:14];
    self.daysCount.text = [NSString stringWithFormat:@"共 %d 晚" , 1];
    [self addSubview:self.daysCount];
    
    UIButton *oneMoreDay = [UIButton buttonWithType:UIButtonTypeCustom];
    oneMoreDay.backgroundColor = [UIColor clearColor];
    [oneMoreDay setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    oneMoreDay.frame = CGRectMake(frame.size.width - 35, 2, 28, 28);
    oneMoreDay.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    [self addSubview:oneMoreDay];
    [oneMoreDay addTarget:self action:@selector(oneMoreDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createHotelChooseCard:(HotelCardDataModel *)model cardIndex:(NSInteger)index
{
    HotelCard *card = [[HotelCard alloc] initWithFrame:CGRectMake(0, self.height, self.width , 0) andDataModel:model];
    card.delegate = self;
    card.index = index;
    
    [self.hotelCardArray addObject:card];
    
    [self addSubview:card];
    self.height += card.frame.size.height + 5;
    
    if (index == 0)
    {
        card.selected = YES;
        [self cardIsSelectedWithDataModel:model CardIndex:index];
    }
    else
    {
        card.selected = NO;
    }
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
            selfblock.endDate = [self dateSomeDays:selfblock.dataModel.durationDays LaterThan:selfblock.beginDate];
            [selfblock.delegate dateChangedOnCellIndex:selfblock.index];
            
            [((UIViewController*)selfblock.delegate).navigationController popViewControllerAnimated:YES];
        };
        
        [((UIViewController*)self.delegate).navigationController pushViewController:chvc animated:YES];
    }
    
}

- (void)lessDayButtonClicked:(id)sender
{
    if (self.dataModel.durationDays >1)
    {
        self.dataModel.durationDays--;
        self.daysCount.text = [NSString stringWithFormat:@"共 %ld 晚" , (long)self.dataModel.durationDays];
        self.endDate = [self preDayFromDate:self.endDate];
        
        if (self.delegate)
        {
            [self.delegate dateChangedOnCellIndex:self.index];
        }
    }
}

- (void)oneMoreDayButtonClicked:(id)sender
{
    self.dataModel.durationDays++;
    self.daysCount.text = [NSString stringWithFormat:@"共 %ld 晚" , (long)self.dataModel.durationDays];
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
        self.dataModel.orderCheckinDate = [self stringFromDate:self.beginDate];
        
        self.checkinDateLabel.text = [NSString stringWithFormat:@"%@--%@" , self.dataModel.orderCheckinDate , [self stringFromDate:self.endDate]];
    }
}

- (void)setEndDate:(NSDate *)endDate
{
    if (_endDate != endDate)
    {
        _endDate = endDate;
        self.dataModel.orderEndDate = [self stringFromDate:self.endDate];
        
        self.checkinDateLabel.text = [NSString stringWithFormat:@"%@--%@" , [self stringFromDate:self.beginDate] , [self stringFromDate:self.endDate]];
    }
}

- (void)cardIsSelectedWithDataModel:(HotelCardDataModel *)cardModel CardIndex:(NSInteger)index
{
    self.dataModel.orderHotelInfo = cardModel;
    
    for (NSInteger i = 0; i < self.hotelCardArray.count; i++)
    {
        if (i != index)
        {
            [(HotelCard *)[self.hotelCardArray objectAtIndex:i] setSelected:false];
        }
    }
    
    [self roomsCountChanged];
}

- (void)roomsCountChanged
{
//    for (NSInteger i=0; i < self.hotelCardArray.count; i++)
//    {
//        HotelCard *card = [self.hotelCardArray objectAtIndex:i];
//        if (card.selected)
//        {
////            self.dataModel.orderRoomsCount = card.roomsCount;
//            self.dataModel.orderPrice = card.roomPrice;
//        }
//    }
    
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
