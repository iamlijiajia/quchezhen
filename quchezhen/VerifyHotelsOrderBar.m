//
//  VerifyHotelsOrderBar.m
//  quchezhen
//
//  Created by lijiajia on 15/7/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "VerifyHotelsOrderBar.h"

@interface VerifyHotelsOrderBar ()

@property (strong , nonatomic) UILabel *priceLabel;
@property (strong , nonatomic) UILabel *daysCountLabel;
@property (strong , nonatomic) UILabel *chekinDateLabel;
@property (strong , nonatomic) UILabel *verifyOrderLabel;

@end

@implementation VerifyHotelsOrderBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor greenColor];
        NSInteger width = frame.size.width;
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0 , width - 200, 15)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.priceLabel];
        
        self.daysCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15 , width - 100, 15)];
        self.daysCountLabel.backgroundColor = [UIColor clearColor];
        self.daysCountLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.daysCountLabel];
        
        self.chekinDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30 , width - 100, 15)];
        self.chekinDateLabel.backgroundColor = [UIColor clearColor];
        self.chekinDateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.chekinDateLabel];

        UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        verifyButton.frame = CGRectMake(width - 140, 0 , 140, 45);
        verifyButton.backgroundColor = [UIColor redColor];
        [verifyButton addTarget:self action:@selector(onVerifyOrderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:verifyButton];
        
        self.verifyOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 120, 0 , 120, 45)];
        //        self.verifyOrderLabel.backgroundColor = [UIColor redColor];
        self.verifyOrderLabel.font = [UIFont systemFontOfSize:28];
        self.verifyOrderLabel.text = @"确认下单";
        [self addSubview:self.verifyOrderLabel];
        
        
        self.price = 0;
        self.daysCount = 0;
        self.checkinDate = nil;
    }
    
    return self;
}

- (void)onVerifyOrderButtonPressed:(id)sender
{
    if (self.delegate)
    {
        [self.delegate onVerifyOrderButtonPressed];
    }
}

- (void)setPrice:(NSInteger)price
{
    self.priceLabel.text = [NSString stringWithFormat:@"共计费用: %ld 元" , (long)price];
}

- (void)setDaysCount:(NSInteger)daysCount
{
    self.daysCountLabel.text = [NSString stringWithFormat:@"共计入住: %ld 晚" , (long)daysCount];
}

- (void)setCheckinDate:(NSString *)checkinDate
{
    self.chekinDateLabel.text = [NSString stringWithFormat:@"首晚入住时间: %@" , checkinDate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
