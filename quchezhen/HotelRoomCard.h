//
//  HotelRoomCard.h
//  quchezhen
//
//  Created by lijiajia on 15/7/28.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelRoomCardDelegate <NSObject>

- (void)cardIsSelectedWithInfo:(NSDictionary *)cardInfo CardIndex:(NSInteger)index;
- (void)roomsCountChanged;

@end

@interface HotelRoomCard : UIView

@property (nonatomic) NSInteger roomPrice;
@property (nonatomic) NSInteger roomsCount;
@property (strong , nonatomic)  id<HotelRoomCardDelegate> delegate;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL selected;

- (id)initWithFrame:(CGRect)frame andHotelInfo:(NSDictionary *)hotelInfo;

@end
