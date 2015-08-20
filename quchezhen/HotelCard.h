//
//  HotelCard.h
//  quchezhen
//
//  Created by lijiajia on 15/7/28.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomCard.h"
#import "HotelCardDataModel.h"

@protocol HotelCardDelegate <NSObject>

- (void)cardIsSelectedWithDataModel:(HotelCardDataModel *)cardModel CardIndex:(NSInteger)index;
- (void)roomsCountChanged;

@end

@interface HotelCard : UIView <RoomsCountDelegate>

@property (strong , nonatomic)  id<HotelCardDelegate> delegate;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL selected;

@property (nonatomic) NSInteger height;

@property (nonatomic , strong) HotelCardDataModel *dataModel;

//- (id)initWithFrame:(CGRect)frame andHotelInfo:(NSDictionary *)hotelInfo;

- (id)initWithFrame:(CGRect)frame andDataModel:(HotelCardDataModel *)dataModel;

@end
