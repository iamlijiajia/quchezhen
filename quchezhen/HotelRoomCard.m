//
//  HotelRoomCard.m
//  quchezhen
//
//  Created by lijiajia on 15/7/28.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HotelRoomCard.h"

@interface HotelRoomCard ()

@property (strong , nonatomic) UILabel *roomsCountLabel;
@property (strong , nonatomic) NSDictionary *cardInfo;
@property (strong , nonatomic) UIButton *LessRoom;
@property (strong , nonatomic) UIButton *oneMoreRoom;

@end

@implementation HotelRoomCard


- (id)initWithFrame:(CGRect)frame andHotelInfo:(NSDictionary *)hotelInfo
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cardInfo = hotelInfo;
        CGFloat width = frame.size.width;
        
        NSString *roomPriceStr = [hotelInfo objectForKey:@"hotelPrice"];
        self.roomPrice =[roomPriceStr integerValue];
        
        self.roomsCount = 1;
        
//        UIImageView *hotelCardBg = [[UIImageView alloc] initWithFrame:frame];
//        [self addSubview:hotelCardBg];
        
        UIButton *hotelCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hotelCardButton.frame = CGRectMake(0, 0, width, frame.size.height);
        [hotelCardButton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hotelCardButton];
        
        UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(5, 0 , width - 100, 15)];
        hotelName.backgroundColor = [UIColor clearColor];
        hotelName.font = [UIFont systemFontOfSize:14];
        hotelName.text = [hotelInfo objectForKey:@"hotelName"];
        [self addSubview:hotelName];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(width - 100, 0 , width , 15)];
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [UIColor redColor];
        price.font = [UIFont systemFontOfSize:14];
        price.text = [NSString stringWithFormat:@"￥%@" , roomPriceStr];
        [self addSubview:price];
        
//        self.height += 15;
        
        UILabel *roomType = [[UILabel alloc] initWithFrame:CGRectMake(5, 15 , width - 100, 12)];
        roomType.backgroundColor = [UIColor clearColor];
        roomType.font = [UIFont systemFontOfSize:12];
        roomType.text = [hotelInfo objectForKey:@"RoomType"];
        [self addSubview:roomType];
        
        self.LessRoom = [UIButton buttonWithType:UIButtonTypeCustom];
        self.LessRoom.backgroundColor = [UIColor grayColor];
        self.LessRoom.frame = CGRectMake(width - 100, 15 , 20 , 15);
        [self.LessRoom addTarget:self action:@selector(lessRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.LessRoom];
        
        
        self.roomsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 70, 15 , 40 , 15)];
        self.roomsCountLabel.backgroundColor = [UIColor clearColor];
        self.roomsCountLabel.font = [UIFont systemFontOfSize:14];
        self.roomsCountLabel.text = [NSString stringWithFormat:@"%d 间" , 1];
        [self addSubview:self.roomsCountLabel];
        
        
        self.oneMoreRoom = [UIButton buttonWithType:UIButtonTypeCustom];
        self.oneMoreRoom.backgroundColor = [UIColor redColor];
        self.oneMoreRoom.frame = CGRectMake(width - 30, 15 , 20 , 15);
        [self addSubview:self.oneMoreRoom];
        [self.oneMoreRoom addTarget:self action:@selector(oneMoreRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        self.height += 12;
        
        UILabel *roomIntro = [[UILabel alloc] initWithFrame:CGRectMake(5, 27 , width - 100, 12)];
        roomIntro.backgroundColor = [UIColor clearColor];
        roomIntro.font = [UIFont systemFontOfSize:8];
        roomIntro.text = [hotelInfo objectForKey:@"RoomIntro"];
        [self addSubview:roomIntro];
//        self.height += 12;
//        
//        self.height += 5;
        self.selected = NO;
    }
    
    return self;
}


- (void)lessRoomButtonClicked:(id)sender
{
    if (self.roomsCount >1)
    {
        self.roomsCount--;
        self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld 间" , (long)self.roomsCount];
        
        if (self.delegate)
        {
            [self.delegate roomsCountChanged];
        }
    }
}

- (void)oneMoreRoomButtonClicked:(id)sender
{
    self.roomsCount++;
    self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld 间" , (long)self.roomsCount];
    
    if (self.delegate)
    {
        [self.delegate roomsCountChanged];
    }
}

- (void)onClicked:(id)sender
{
    self.selected = YES;
    
    if (self.delegate)
    {
        [self.delegate cardIsSelectedWithInfo:self.cardInfo CardIndex:self.index];
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selected)
    {
        self.backgroundColor = [UIColor blueColor];
        
        self.LessRoom.hidden = NO;
        self.roomsCountLabel.hidden = NO;
        self.oneMoreRoom.hidden = NO;
    }
    else
    {
        self.backgroundColor = [UIColor yellowColor];
        
        self.LessRoom.hidden = YES;
        self.roomsCountLabel.hidden = YES;
        self.oneMoreRoom.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
