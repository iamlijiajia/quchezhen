//
//  VerifyHotelsOrderBar.m
//  quchezhen
//
//  Created by lijiajia on 15/7/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "VerifyHotelsOrderBar.h"
#import "UIView+Utilities.h"

@interface VerifyHotelsOrderBar ()

@property (strong , nonatomic) UILabel *priceLabel;
@property (strong , nonatomic) UILabel *daysCountLabel;
@property (strong , nonatomic) UILabel *chekinDateLabel;
@property (strong , nonatomic) UIButton *verifyButton;

@end

@implementation VerifyHotelsOrderBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start-travl-foot-bg@3x.png"]];
        bgView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:bgView];
        NSInteger width = frame.size.width;
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 5 , width - 72 - 86 - 5, 20)];
        self.priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1];
        self.priceLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.priceLabel];
        
        self.chekinDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 28 , width - 72 - 86 - 5, 15)];
        self.chekinDateLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.56];
        self.chekinDateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.chekinDateLabel];

        self.daysCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 16 , 72, 14)];
        self.daysCountLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.87];
        self.daysCountLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.daysCountLabel];
        
        self.verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.verifyButton.frame = CGRectMake(width - 86 - 5, 4 , 86 , 37);
        [self.verifyButton setImage:[UIImage imageNamed:@"foot-btn-send-default@3x.png"] forState:UIControlStateNormal];
        [self.verifyButton addTarget:self action:@selector(onVerifyOrderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.verifyButton];
        
        self.price = 0;
        self.daysCount = 0;
        self.checkinDate = @"";
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
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld" , (long)price];
}

- (void)setDaysCount:(NSInteger)daysCount
{
    _daysCount = daysCount;
    self.daysCountLabel.text = [NSString stringWithFormat:@"共 %ld 晚" , (long)daysCount];
}

- (void)setCheckinDate:(NSString *)checkinDate
{
    _checkinDate = checkinDate;
    self.chekinDateLabel.text = [NSString stringWithFormat:@"从 %@ 起" , checkinDate];
}

- (void)setVerifyButtonImage:(UIImage *)verifyButtonImage
{
    [self.verifyButton setImage:verifyButtonImage forState:UIControlStateNormal];
}

@end
