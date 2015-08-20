//
//  RoomCardDataModel.h
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomCardDataModel : NSObject

- (id)initWithDictionary:(NSDictionary *)dic;


@property (nonatomic) NSInteger roomPrice;
@property (nonatomic) NSInteger roomsCount;
@property (nonatomic , strong) NSString *roomType;
@property (nonatomic , strong) NSString *roomIntro;

@end
