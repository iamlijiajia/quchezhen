//
//  RoomOrdersDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "RoomOrdersDataModel.h"
#import "NSDate+Utilities.h"

@interface RoomOrdersDataModel ()

@property (nonatomic , strong) NSString *checkinDate;
@property (nonatomic , strong)BmobObject *bmobRouteObject;

@end

@implementation RoomOrdersDataModel



- (id)initWithBmobObject:(BmobObject *)obj
{
    self = [super init];
    if (self)
    {
        self.bmobRouteObject = obj;
        self.routeName = [obj objectForKey:@"name"];
        self.CitiesCellViewModelArray = [NSMutableArray arrayWithCapacity:5];
        NSArray *cities = [obj objectForKey:@"city_of_hotel_Info"];
        for (NSInteger i = 0; i < cities.count; i++)
        {
            BookRoomViewCellDataModel *model = [[BookRoomViewCellDataModel alloc] initWithDictionary:[cities objectAtIndex:i]];
            [self.CitiesCellViewModelArray addObject:model];
        }
    }
    
    return self;
}

- (NSInteger)orderPrice
{
    NSInteger price = 0;
    
    for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
    {
        price += model.orderPrice;
    }
    
    return price;
}

- (NSInteger)durationDays
{
    NSInteger duaration = 0;
    
    for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
    {
        if (model.orderRoomsCount > 0)
        {
            duaration += model.durationDays;
        }
    }
    
    return duaration;
}

- (void)setOrderCheckinDate:(NSString *)orderCheckinDate
{
    if (self.CitiesCellViewModelArray.count)
    {
        BookRoomViewCellDataModel *model = [self.CitiesCellViewModelArray objectAtIndex:0];
        model.orderCheckinDate = orderCheckinDate;
    }
    else
    {
        self.checkinDate = orderCheckinDate;
    }
}

- (NSString *)orderCheckinDate
{
    if (self.CitiesCellViewModelArray.count)
    {
        BookRoomViewCellDataModel *model = [self.CitiesCellViewModelArray objectAtIndex:0];
        return model.orderCheckinDate;
    }
    
    if (self.CitiesCellViewModelArray.count)
    {
        NSDate *checkinDate = nil;
        for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
        {
            if (!checkinDate)
            {
                checkinDate = [NSDate dateWithString:model.orderCheckinDate formate:@"yyyy-MM-dd"];
            }
            else
            {
                NSDate *tempDate = [NSDate dateWithString:model.orderCheckinDate formate:@"yyyy-MM-dd"];
                if (checkinDate.timeIntervalSince1970 > tempDate.timeIntervalSince1970 )
                {
                    checkinDate = tempDate;
                }
            }
        }
        
        return [checkinDate stringWithSeperator:@"-"];
    }
    
    return self.checkinDate;
}

- (NSString *)orderCheckoutDate
{
    if (self.CitiesCellViewModelArray.count)
    {
        NSDate *checkoutDate = nil;
        for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
        {
            if (!checkoutDate)
            {
                checkoutDate = [NSDate dateWithString:model.orderEndDate formate:@"yyyy-MM-dd"];
            }
            else
            {
                NSDate *tempDate = [NSDate dateWithString:model.orderEndDate formate:@"yyyy-MM-dd"];
                if (checkoutDate.timeIntervalSince1970 < tempDate.timeIntervalSince1970 )
                {
                    checkoutDate = tempDate;
                }
            }
        }

        return [checkoutDate stringWithSeperator:@"-"];
    }
    
    return nil;
}

- (NSInteger)orderRoomsCount
{
    NSInteger roomCount = 0;
    
    for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
    {
        if(roomCount < model.orderRoomsCount)
        {
            roomCount = model.orderRoomsCount;
        }
    }
    
    return roomCount;
}

- (NSArray *)cellWithOrderHotelsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
    {
        if (model.orderHotelInfo)
        {
            [array addObject:model];
        }
    }
    
    return array;
}

@end
