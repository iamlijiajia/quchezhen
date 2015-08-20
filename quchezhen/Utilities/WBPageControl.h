//
//  WBPageControl.h
//  Weibo
//
//  Created by Wade Cheng on 8/8/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPageControl : UIView
{
    NSInteger numberOfPages;
	NSInteger currentPage;
    
    UIImage *pageIndicatorImage;
    UIImage *currentPageIndicatorImage;
    
    CGFloat indicatorSpace;
}

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hidesForSinglePage;

@property (nonatomic, retain) UIImage *pageIndicatorImage;
@property (nonatomic, retain) UIImage *currentPageIndicatorImage;
@property (nonatomic, assign) CGFloat indicatorSpace;

- (void)reloadUIElements;

@end
