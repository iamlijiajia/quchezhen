//
//  RoomCard.h
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomCardDataModel.h"

@protocol RoomsCountDelegate <NSObject>

- (void)roomsCountChanged;

@end

@interface RoomCard : UIView

//@property (nonatomic) NSInteger roomPrice;
@property (nonatomic , strong) RoomCardDataModel *dataModel;
@property (nonatomic , strong) id<RoomsCountDelegate> delegate;

@property (nonatomic) BOOL isSelected;

- (id)initWithRoomCardDataModel:(RoomCardDataModel *)roomData Frame:(CGRect)frame;
- (void)createRoomCardWithDataModel:(RoomCardDataModel *)roomData Frame:(CGRect)frame;

- (void)setRoomsCountLabelHidden:(BOOL)hidden;

@end
