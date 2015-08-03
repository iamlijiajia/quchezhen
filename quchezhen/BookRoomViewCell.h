//
//  BookRoomViewCell.h
//  quchezhen
//
//  Created by lijiajia on 15/7/17.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomOrderCellModel.h"

@protocol BookRoomViewCellDelegate <NSObject>

- (void)dateChangedOnCellIndex:(NSInteger)index;
- (void)orderChanged;

@end

@interface BookRoomViewCell : UIView

@property (strong , nonatomic) id<BookRoomViewCellDelegate> delegate;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger index;

@property (strong , nonatomic) RoomOrderCellModel *orderModel;

@property (strong , nonatomic) NSDate *beginDate;
@property (strong , nonatomic) NSDate *endDate;

//@property (nonatomic) NSInteger durationDays;
//
//@property (strong , nonatomic)NSDictionary *orderRoomInfo;   //订购的房间的信息
//@property (nonatomic)NSInteger orderPrice;      //这个cell的订单总价格
//@property (nonatomic)NSInteger orderRoomsCount; //订购的房间总数
//@property (nonatomic)NSString *orderCheckinDate;    //订单开始日期，与beginDate日期相同

- (id)initWithRoomsDictionary:(NSDictionary *)dic Date:(NSDate *)date andFrameWith:(NSInteger)width;

@end
