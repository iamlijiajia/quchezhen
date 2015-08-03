//
//  RoomOrderCellModel.h
//  quchezhen
//
//  Created by lijiajia on 15/7/30.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomOrderCellModel : NSObject

//@property (strong , nonatomic) NSDate *beginDate;
//@property (strong , nonatomic) NSDate *endDate;

@property (nonatomic) NSInteger durationDays;

@property (strong , nonatomic)NSDictionary *orderRoomInfo;   //订购的房间的信息
@property (nonatomic)NSInteger orderPrice;      //这个cell的订单总价格
@property (nonatomic)NSInteger orderRoomsCount; //订购的房间总数
@property (nonatomic)NSString *orderCheckinDate;    //订单开始日期
@property (nonatomic)NSString *orderEndDate;    //订单结束日期

@end
