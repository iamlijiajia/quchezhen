//
//  RoomOrdersDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "RoomOrdersDataModel.h"

@interface RoomOrdersDataModel ()

@property (nonatomic , strong) NSString *checkinDate;

@end

@implementation RoomOrdersDataModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.CitiesCellViewModelArray = [NSMutableArray arrayWithCapacity:5];
        NSArray *cities = [dic objectForKey:@"city_of_hotel_Info"];
        for (NSInteger i = 0; i < cities.count; i++)
        {
            BookRoomViewCellDataModel *model = [[BookRoomViewCellDataModel alloc] initWithDictionary:[cities objectAtIndex:i]];
            [self.CitiesCellViewModelArray addObject:model];
        }
    }
    
    return self;
}

- (id)initWithBmobObject:(BmobObject *)obj
{
    self = [super init];
    if (self)
    {
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
    
    return self.checkinDate;
}

- (NSInteger)orderRoomsCount
{
    NSInteger roomCount = 0;
    
    for (BookRoomViewCellDataModel *model in self.CitiesCellViewModelArray)
    {
        roomCount += model.orderRoomsCount;
    }
    
    return roomCount;
}

@end
