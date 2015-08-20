//
//  BookRoomViewCellDataModel.h
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelCardDataModel.h"

@interface BookRoomViewCellDataModel : NSObject

@property (nonatomic)NSString *mapName;

@property (nonatomic) NSInteger durationDays;

@property (strong , nonatomic)HotelCardDataModel *orderHotelInfo;   //订购的酒店的信息
@property (nonatomic , readonly)NSInteger orderPrice;      //这个cell的订单总价格

@property (nonatomic , readonly)NSInteger orderRoomsCount; //订购的房间总数
@property (nonatomic , strong)NSString *orderCheckinDate;    //订单开始日期
@property (nonatomic)NSString *orderEndDate;    //订单结束日期

@property (nonatomic , strong) NSMutableArray *hotelCardDataModels;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
