//
//  BookRoomViewCellDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "BookRoomViewCellDataModel.h"

@implementation BookRoomViewCellDataModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.hotelCardDataModels = [NSMutableArray arrayWithCapacity:5];
        self.mapName = [dic objectForKey:@"hotelMapImage"];
        
        NSArray *hotels = [dic objectForKey:@"hotelInfo"];
        for (NSInteger i = 0; i < hotels.count; i++)
        {
            HotelCardDataModel *model = [[HotelCardDataModel alloc] initWithDictionary:[hotels objectAtIndex:i]];
            [self.hotelCardDataModels addObject:model];
        }
    }
    
    return self;
}

- (NSInteger)orderPrice
{
    NSInteger price = 0;
    
    for (HotelCardDataModel *model in self.hotelCardDataModels)
    {
        if (model.selected)
        {
            price += model.orderPrice;
        }
    }
    
    price = price * self.durationDays;
    
    return price;
}

- (NSInteger)orderRoomsCount
{
    NSInteger roomsCount = 0;
    
    for (HotelCardDataModel *model in self.hotelCardDataModels)
    {
        if (model.selected)
        {
            roomsCount = model.orderRoomsCount;
        }
    }
    
    return roomsCount;
}

@end
