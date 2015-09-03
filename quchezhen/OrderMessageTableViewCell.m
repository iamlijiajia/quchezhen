//
//  OrderMessageTableViewCell.m
//  quchezhen
//
//  Created by lijiajia on 15/8/31.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "OrderMessageTableViewCell.h"
#import "config.h"
#import "UIView+Utilities.h"
#import "UIAlertView+Blocks.h"
#import <BmobSDK/Bmob.h>

@implementation OrderMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellDataModel:(BookRoomViewCellDataModel *)model andWidth:(CGFloat)width
{
    UILabel *hotelName = [[UILabel alloc] init];
    hotelName.frame = CGRectMake(0, 8, width, 16);
    hotelName.font = [UIFont boldSystemFontOfSize:16];
    hotelName.textColor = RGB_Color(51.0, 51.0, 51.0);
    hotelName.textAlignment = NSTextAlignmentCenter;
    hotelName.text = model.orderHotelInfo.hotelName;
    [self addSubview:hotelName];
    
    UILabel *location = [[UILabel alloc] init];
    location.frame = CGRectMake(0, hotelName.bottom + 11, width, 10);
    location.font = [UIFont systemFontOfSize:10];
    location.textColor = RGB_Color(142.0, 142.0, 142.0);
    location.textAlignment = NSTextAlignmentCenter;
    location.text = model.orderHotelInfo.hotelLocation;
    [self addSubview:location];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1pd-line@3x.png"]];
    line.frame = CGRectMake((width-272)/2, location.bottom + 9, 272, 1);
    [self addSubview:line];
    
    UILabel *checkInOutDate = [[UILabel alloc] init];
    checkInOutDate.frame = CGRectMake(0, line.bottom + 5, width, 12);
    checkInOutDate.font = [UIFont systemFontOfSize:12];
    checkInOutDate.textColor = RGB_Color(51.0, 51.0, 51.0);
    checkInOutDate.textAlignment = NSTextAlignmentCenter;
    checkInOutDate.text = [NSString stringWithFormat:@"%@ 至 %@" , model.orderCheckinDate , model.orderEndDate];
    [self addSubview:checkInOutDate];
    
    CGFloat positionY = checkInOutDate.bottom + 12;
    for (RoomCardDataModel *room in model.orderHotelInfo.roomCardDataArray)
    {
        if (room.roomsCount)
        {
            UILabel *roomType = [[UILabel alloc] init];
            roomType.frame = CGRectMake(30, positionY, 112 - 30, 16);
            roomType.font = [UIFont boldSystemFontOfSize:16];
            roomType.textColor = RGB_Color(51.0, 51.0, 51.0);
            roomType.textAlignment = NSTextAlignmentLeft;
            roomType.text = room.roomType;
            [self addSubview:roomType];
            
            UILabel *roomCount = [[UILabel alloc] init];
            roomCount.frame = CGRectMake(112, positionY, 90, 16);
            roomCount.font = [UIFont boldSystemFontOfSize:16];
            roomCount.textColor = RGB_Color(51.0, 51.0, 51.0);
            roomCount.textAlignment = NSTextAlignmentLeft;
            roomCount.text = [NSString stringWithFormat:@"%ld 间" , (long)room.roomsCount];
            [self addSubview:roomCount];
            
            UILabel *priceAll = [[UILabel alloc] init];
            priceAll.frame = CGRectMake(228, positionY, width - 228, 16);
            priceAll.font = [UIFont boldSystemFontOfSize:16];
            priceAll.textColor = RGB_Color(51.0, 51.0, 51.0);
            priceAll.textAlignment = NSTextAlignmentLeft;
            priceAll.text = [NSString stringWithFormat:@"￥%ld" , room.roomsCount * room.roomPrice];
            [self addSubview:priceAll];
            
            UILabel *roomIntro = [[UILabel alloc] init];
            roomIntro.frame = CGRectMake(30, priceAll.bottom + 5, width - 30, 10);
            roomIntro.font = [UIFont systemFontOfSize:10];
            roomIntro.textColor = RGB_Color(142.0, 142.0, 142.0);
            roomIntro.textAlignment = NSTextAlignmentLeft;
            roomIntro.text = room.roomIntro;
            [self addSubview:roomIntro];
            
            positionY += 16 + 5 + 20;
        }
    }
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.frame = CGRectMake(30, positionY, 112 - 30, 12);
    telLabel.font = [UIFont systemFontOfSize:12];
    telLabel.textColor = RGB_Color(142.0, 142.0, 142.0);
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.text = @"酒店电话:";
    [self addSubview:telLabel];
    
    UIButton *telNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    [telNumber setTitle:model.orderHotelInfo.hotelTel forState:UIControlStateNormal];
    [telNumber setTitleColor:RGB_Color(0.0, 111.0, 252.0) forState:UIControlStateNormal];
    telNumber.titleLabel.font = [UIFont systemFontOfSize:12];
    telNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    telNumber.frame = CGRectMake(112, positionY, width - 112, 12);
    [telNumber addTarget:self action:@selector(callTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:telNumber];
    
    positionY += 12 + 18;
    
    self.frame = CGRectMake(0, 0, width, positionY);
}


- (void)configureCellWithOrderItems:(NSArray *)orderItems andWidth:(CGFloat)width
{
    if (!orderItems.count)
    {
        return;
    }
    
    BmobObject *item = [orderItems objectAtIndex:0];
    
    UILabel *hotelName = [[UILabel alloc] init];
    hotelName.frame = CGRectMake(0, 8, width, 16);
    hotelName.font = [UIFont boldSystemFontOfSize:16];
    hotelName.textColor = RGB_Color(51.0, 51.0, 51.0);
    hotelName.textAlignment = NSTextAlignmentCenter;
    hotelName.text = [item objectForKey:@"hotelName"];
    [self addSubview:hotelName];
    
    UILabel *location = [[UILabel alloc] init];
    location.frame = CGRectMake(0, hotelName.bottom + 11, width, 10);
    location.font = [UIFont systemFontOfSize:10];
    location.textColor = RGB_Color(142.0, 142.0, 142.0);
    location.textAlignment = NSTextAlignmentCenter;
    location.text = [item objectForKey:@"hotelLocation"];
    [self addSubview:location];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1pd-line@3x.png"]];
    line.frame = CGRectMake((width-272)/2, location.bottom + 9, 272, 1);
    [self addSubview:line];
    
    UILabel *checkInOutDate = [[UILabel alloc] init];
    checkInOutDate.frame = CGRectMake(0, line.bottom + 5, width, 12);
    checkInOutDate.font = [UIFont systemFontOfSize:12];
    checkInOutDate.textColor = RGB_Color(51.0, 51.0, 51.0);
    checkInOutDate.textAlignment = NSTextAlignmentCenter;
    checkInOutDate.text = [NSString stringWithFormat:@"%@ 至 %@" , [item objectForKey:@"orderCheckinDate"] , [item objectForKey:@"orderEndDate"]];
    [self addSubview:checkInOutDate];
    
    CGFloat positionY = checkInOutDate.bottom + 12;
    for (BmobObject *orderItem in orderItems)
    {
        UILabel *roomType = [[UILabel alloc] init];
        roomType.frame = CGRectMake(30, positionY, 112 - 30, 16);
        roomType.font = [UIFont boldSystemFontOfSize:16];
        roomType.textColor = RGB_Color(51.0, 51.0, 51.0);
        roomType.textAlignment = NSTextAlignmentLeft;
        roomType.text = [orderItem objectForKey:@"roomType"];
        [self addSubview:roomType];
        
        UILabel *roomCount = [[UILabel alloc] init];
        roomCount.frame = CGRectMake(112, positionY, 90, 16);
        roomCount.font = [UIFont boldSystemFontOfSize:16];
        roomCount.textColor = RGB_Color(51.0, 51.0, 51.0);
        roomCount.textAlignment = NSTextAlignmentLeft;
        NSNumber *count = [orderItem objectForKey:@"roomsCount"];
        roomCount.text = [NSString stringWithFormat:@"%ld 间" , count.integerValue];
        [self addSubview:roomCount];
        
        UILabel *priceAll = [[UILabel alloc] init];
        priceAll.frame = CGRectMake(228, positionY, width - 228, 16);
        priceAll.font = [UIFont boldSystemFontOfSize:16];
        priceAll.textColor = RGB_Color(51.0, 51.0, 51.0);
        priceAll.textAlignment = NSTextAlignmentLeft;
        NSNumber *price = [orderItem objectForKey:@"roomPrice"];
        priceAll.text = [NSString stringWithFormat:@"￥%ld" , count.integerValue * price.integerValue];
        [self addSubview:priceAll];
        
        UILabel *roomIntro = [[UILabel alloc] init];
        roomIntro.frame = CGRectMake(30, priceAll.bottom + 5, width - 30, 10);
        roomIntro.font = [UIFont systemFontOfSize:10];
        roomIntro.textColor = RGB_Color(142.0, 142.0, 142.0);
        roomIntro.textAlignment = NSTextAlignmentLeft;
        roomIntro.text = [orderItem objectForKey:@"roomIntro"];
        [self addSubview:roomIntro];
        
        positionY += 16 + 5 + 20;
    }
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.frame = CGRectMake(30, positionY, 112 - 30, 12);
    telLabel.font = [UIFont systemFontOfSize:12];
    telLabel.textColor = RGB_Color(142.0, 142.0, 142.0);
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.text = @"酒店电话:";
    [self addSubview:telLabel];
    
    UIButton *telNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    [telNumber setTitle:[item objectForKey:@"hotelTel"] forState:UIControlStateNormal];
    [telNumber setTitleColor:RGB_Color(0.0, 111.0, 252.0) forState:UIControlStateNormal];
    telNumber.titleLabel.font = [UIFont systemFontOfSize:12];
    telNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    telNumber.frame = CGRectMake(112, positionY, width - 112, 12);
    [telNumber addTarget:self action:@selector(callTelNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:telNumber];
    
    positionY += 12 + 18;
    
    self.frame = CGRectMake(0, 0, width, positionY);
}

- (void)callTelNumber:(id)sender
{
    NSString *tel = [(UIButton *)sender titleLabel].text;
    if (tel)
    {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
        RIButtonItem *call = [RIButtonItem itemWithLabel:@"拨打" action:^{
            NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
            [[UIApplication sharedApplication] openURL:phoneNumberURL];
        }];
        
        [UIAlertView alertWithTitle:nil message:tel cancelButtonItem:cancel otherButtonItems:call , nil];
    }
}

@end
