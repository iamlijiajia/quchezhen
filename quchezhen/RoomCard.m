//
//  RoomCard.m
//  quchezhen
//
//  Created by lijiajia on 15/8/5.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "RoomCard.h"

@interface RoomCard ()

@property (strong , nonatomic) UILabel *roomsCountLabel;
@property (strong , nonatomic) NSDictionary *cardInfo;
@property (strong , nonatomic) UIButton *LessRoom;
@property (strong , nonatomic) UIButton *oneMoreRoom;
@property (strong , nonatomic) UIImageView *bgView;

@end

@implementation RoomCard

- (id)initWithRoomCardDataModel:(RoomCardDataModel *)roomData Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataModel = roomData;
        [self createRoomCardWithDataModel:roomData Frame:frame];
    }
    
    return self;
}

- (void)createRoomCardWithDataModel:(RoomCardDataModel *)roomData Frame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    
    UIImage *backgroundImg = [UIImage imageNamed:@"start-travl-bg-room-selected@3x.png"];
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, frame.size.height)];
    self.bgView.image = backgroundImg;
    [self addSubview:self.bgView];
    
    UILabel *roomType = [[UILabel alloc] initWithFrame:CGRectMake(13, 11 , 100, 20)];
    roomType.backgroundColor = [UIColor clearColor];
    roomType.font = [UIFont systemFontOfSize:14];
    roomType.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    roomType.text = roomData.roomType;
    [self addSubview:roomType];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(115, 11 , 80 , 20)];
    price.textColor = [UIColor colorWithRed:255.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1];
    price.font = [UIFont systemFontOfSize:18];
    price.text = [NSString stringWithFormat:@"￥%ld" , (long)roomData.roomPrice];
    [self addSubview:price];
    
    UILabel *roomIntro = [[UILabel alloc] initWithFrame:CGRectMake(13, 33 , width - 13, 15)];
    roomIntro.backgroundColor = [UIColor clearColor];
    roomIntro.font = [UIFont systemFontOfSize:10];
    roomIntro.textColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1];
    roomIntro.text = roomData.roomIntro;
    [self addSubview:roomIntro];
    
    self.LessRoom = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.LessRoom setImage:[UIImage imageNamed:@"less.png"] forState:UIControlStateNormal];
    self.LessRoom.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.LessRoom.frame = CGRectMake(width - 120, 5 , 30 , 30);
    [self.LessRoom addTarget:self action:@selector(lessRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.LessRoom];
    
    
    self.roomsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 90, 5 , 50 , 30)];
    self.roomsCountLabel.textAlignment = NSTextAlignmentCenter;
    self.roomsCountLabel.backgroundColor = [UIColor clearColor];
    self.roomsCountLabel.font = [UIFont systemFontOfSize:14];
    self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld 间" , (long)roomData.roomsCount];
    [self addSubview:self.roomsCountLabel];
    
    
    self.oneMoreRoom = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.oneMoreRoom setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    self.oneMoreRoom.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.oneMoreRoom.frame = CGRectMake(width - 40, 5 , 30 , 30);
    [self addSubview:self.oneMoreRoom];
    [self.oneMoreRoom addTarget:self action:@selector(oneMoreRoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)lessRoomButtonClicked:(id)sender
{
    if (self.dataModel.roomsCount > 0)
    {
        self.dataModel.roomsCount--;
        self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld 间" , (long)self.dataModel.roomsCount];
        
        if (self.delegate)
        {
            [self.delegate roomsCountChanged];
        }
    }
}

- (void)oneMoreRoomButtonClicked:(id)sender
{
    self.dataModel.roomsCount++;
    self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld 间" , (long)self.dataModel.roomsCount];
    
    if (self.delegate)
    {
        [self.delegate roomsCountChanged];
    }
}

- (void)setRoomsCountLabelHidden:(BOOL)hidden
{
    self.LessRoom.hidden = hidden;
    self.roomsCountLabel.hidden = hidden;
    self.oneMoreRoom.hidden = hidden;
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        UIImage *backgroundImg = [UIImage imageNamed:@"start-travl-bg-room-selected@3x.png"];
        self.bgView.image = backgroundImg;
    }
    else
    {
        UIImage *backgroundImg = [UIImage imageNamed:@"start-travl-bg-room-default@3x.png"];
        self.bgView.image = backgroundImg;
    }
}

@end
