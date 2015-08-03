//
//  VerifyHotelsOrderBar.h
//  quchezhen
//
//  Created by lijiajia on 15/7/29.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerifyHotelsOrderBarDelegate <NSObject>

- (void)onVerifyOrderButtonPressed;

@end

@interface VerifyHotelsOrderBar : UIView

@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger daysCount;
@property (strong , nonatomic) NSString *checkinDate;
@property (strong , nonatomic) id<VerifyHotelsOrderBarDelegate> delegate;

@end
