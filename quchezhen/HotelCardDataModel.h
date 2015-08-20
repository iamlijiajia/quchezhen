//
//  HotelCardDataModel.h
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomCardDataModel.h"

@interface HotelCardDataModel : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL selected;
@property (nonatomic , strong) NSString *hotelName;
@property (nonatomic , strong) NSMutableArray *roomCardDataArray;
@property (nonatomic , readonly) NSInteger orderPrice;
@property (nonatomic , readonly) NSInteger orderRoomsCount;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
