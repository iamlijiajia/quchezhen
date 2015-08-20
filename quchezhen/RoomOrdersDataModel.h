//
//  RoomOrdersDataModel.h
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookRoomViewCellDataModel.h"
#import <BmobSDK/Bmob.h>

@interface RoomOrdersDataModel : NSObject

@property (nonatomic , readonly)NSInteger orderPrice;      //订单总价格
@property (nonatomic , readonly) NSInteger durationDays;   //订单住宿总天数
@property (nonatomic , readonly)NSInteger orderRoomsCount;   //订单房间总数，每个房间需要添加一个联系人姓名的

@property (nonatomic ,strong) NSString *orderCheckinDate;  //订单开始日期

@property (nonatomic , strong) NSMutableArray *CitiesCellViewModelArray;

- (id)initWithDictionary:(NSDictionary *)dic;

- (id)initWithBmobObject:(BmobObject *)obj;

@end
