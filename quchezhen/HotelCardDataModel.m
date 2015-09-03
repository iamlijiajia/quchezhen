//
//  HotelCardDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HotelCardDataModel.h"

@implementation HotelCardDataModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.selected = NO;
        self.hotelName = [dic objectForKey:@"hotelName"];
        self.hotelTel = [dic objectForKey:@"hotelTel"];
        self.hotelLocation = [dic objectForKey:@"hotelLocation"];
        NSArray *rooms = [dic objectForKey:@"rooms"];
        self.roomCardDataArray = [NSMutableArray arrayWithCapacity:5];
        
        for (int i=0; i < rooms.count; i++)
        {
            RoomCardDataModel *model = [[RoomCardDataModel alloc] initWithDictionary:[rooms objectAtIndex:i]];
            [self.roomCardDataArray addObject:model];
        }
    }
    
    return self;
}

- (NSInteger)orderPrice
{
    NSInteger price = 0;
    
    for (RoomCardDataModel *model in self.roomCardDataArray)
    {
        price += model.roomPrice * model.roomsCount;
    }
    
    return price;
}

- (NSInteger)orderRoomsCount
{
    NSInteger roomsCount = 0;
    
    for (RoomCardDataModel *model in self.roomCardDataArray)
    {
        roomsCount += model.roomsCount;
    }
    
    return roomsCount;
}

@end
