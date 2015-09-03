//
//  HotelCard.m
//  quchezhen
//
//  Created by lijiajia on 15/7/28.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "HotelCard.h"

@interface HotelCard ()

@property (strong , nonatomic) NSDictionary *cardInfo;
@property (strong , nonatomic) UIImageView *hotelCardNameBg;

@end

@implementation HotelCard

- (id)initWithFrame:(CGRect)frame andDataModel:(HotelCardDataModel *)dataModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataModel = dataModel;
        self.height = 0;
        
        CGFloat width = frame.size.width;
        
        self.hotelCardNameBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , width, 30)];
        self.hotelCardNameBg.image = [UIImage imageNamed:@"start-travl-bg-hotel-selected@3x.png"];
        [self addSubview:self.hotelCardNameBg];

        UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , width, 30)];
        self.height += 30;
        
        hotelName.textAlignment = NSTextAlignmentCenter;
        hotelName.backgroundColor = [UIColor clearColor];
        hotelName.font = [UIFont systemFontOfSize:18];
        hotelName.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        hotelName.text = dataModel.hotelName;
        [self addSubview:hotelName];

        [self CreateRoomCards];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, self.height);

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)CreateRoomCards
{
    for (RoomCardDataModel *model in self.dataModel.roomCardDataArray)
    {
        CGRect roomCardFrame = CGRectMake(0, self.height, self.frame.size.width, 52);
        RoomCard *card = [[RoomCard alloc] initWithRoomCardDataModel:model Frame:roomCardFrame];
        self.height += 52;
        card.delegate = self;
        [self addSubview:card];
    }
}

- (void)roomsCountChanged
{
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
        [self.delegate cardIsSelectedWithDataModel:self.dataModel CardIndex:self.index];
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.dataModel.selected = selected;
    
    if (_selected)
    {
        self.hotelCardNameBg.image = [UIImage imageNamed:@"start-travl-bg-hotel-selected@3x.png"];
        
        for (UIView *subView in [self subviews])
        {
            if ([subView isKindOfClass:[RoomCard class]])
            {
                [(RoomCard *)subView setIsSelected:YES];
                [(RoomCard *)subView setRoomsCountLabelHidden:NO];
            }
        }
    }
    else
    {
        self.hotelCardNameBg.image = [UIImage imageNamed:@"start-travl-bg-hotel-default@3x.png"];
        
        for (UIView *subView in [self subviews])
        {
            if ([subView isKindOfClass:[RoomCard class]])
            {
                [(RoomCard *)subView setIsSelected:NO];
                [(RoomCard *)subView setRoomsCountLabelHidden:YES];
            }
        }
    }
}

- (void)setAllRoomCardsRoomCountHidden:(BOOL)hidden
{
    for (UIView *subview in [self subviews])
    {
        if ([subview isKindOfClass:[RoomCard class]])
        {
            [(RoomCard *)subview setRoomsCountLabelHidden:hidden];
        }
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
