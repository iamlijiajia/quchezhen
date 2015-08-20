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
        
        UIImageView *hotelCardBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , width, 30)];
        hotelCardBg.image = [UIImage imageNamed:@"navigationbar_background.png"];
        [self addSubview:hotelCardBg];

        UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , width, 30)];
        self.height += 30;
        
        hotelName.textAlignment = NSTextAlignmentCenter;
        hotelName.backgroundColor = [UIColor clearColor];
        hotelName.font = [UIFont systemFontOfSize:18];
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
        CGRect roomCardFrame = CGRectMake(0, self.height, self.frame.size.width, 50);
        self.height += 50;
        
        RoomCard *card = [[RoomCard alloc] initWithRoomCardDataModel:model Frame:roomCardFrame];
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
        self.backgroundColor = [UIColor lightGrayColor];
        [self setAllRoomCardsRoomCountHidden:NO];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [self setAllRoomCardsRoomCountHidden:YES];
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
