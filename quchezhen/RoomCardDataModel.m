//
//  RoomCardDataModel.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "RoomCardDataModel.h"

@implementation RoomCardDataModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        NSString *roomPriceStr = [dic objectForKey:@"roomPrice"];
        self.roomPrice =[roomPriceStr integerValue];
        self.roomsCount = 0;
        
        self.roomType = [dic objectForKey:@"roomType"];
        self.roomIntro = [dic objectForKey:@"roomIntro"];
        
    }
    
    return self;
}

@end
