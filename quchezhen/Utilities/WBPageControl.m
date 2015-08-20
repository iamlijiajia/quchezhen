//
//  WBPageControl.m
//  Weibo
//
//  Created by Wade Cheng on 8/8/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "WBPageControl.h"

@implementation WBPageControl

@synthesize numberOfPages;
@synthesize currentPage;
@synthesize hidesForSinglePage;
@synthesize pageIndicatorImage;
@synthesize currentPageIndicatorImage;
@synthesize indicatorSpace;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        pageIndicatorImage = [[UIImage skinImageNamed:@"timeline_trend_pagecontrol_point.png"] retain];
        currentPageIndicatorImage = [[UIImage skinImageNamed:@"timeline_trend_pagecontrol_current_point.png"] retain];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [pageIndicatorImage release], pageIndicatorImage = nil;
    [currentPageIndicatorImage release], currentPageIndicatorImage = nil;
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if (self.numberOfPages == 0) return;
 
    if (indicatorSpace <= 0)
    {
        indicatorSpace = 10;
    }
    
    BOOL hasCurrentPage = (self.currentPage >= 0 && self.currentPage < self.numberOfPages);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height);
    CGContextConcatCTM(context, transform);
    
    CGSize indicatorSize = pageIndicatorImage.size;
    CGSize currentIndicatorSize = currentPageIndicatorImage.size;
    CGFloat indicatorsTotalWidth = (self.numberOfPages - 1) * (indicatorSize.width + indicatorSpace) +  (hasCurrentPage ? indicatorSize.width : currentIndicatorSize.width);
    
    CGFloat baseX = ceilf((rect.size.width - indicatorsTotalWidth) / 2);
    CGFloat indicatorY = ceilf((rect.size.height - indicatorSize.height) / 2);
    CGFloat currentIndicatorY = ceilf((rect.size.height - currentIndicatorSize.height) / 2);
    
    for (NSInteger i = 0 ; i < self.numberOfPages ; i ++)
    {
        if (i == self.currentPage)
        {
            CGRect indicatorRect = CGRectMake(baseX, currentIndicatorY, currentIndicatorSize.width, currentIndicatorSize.height);
            CGContextDrawImage(context, indicatorRect, currentPageIndicatorImage.CGImage);
            baseX += currentPageIndicatorImage.size.width;
        }
        else
        {
            CGRect indicatorRect = CGRectMake(baseX, indicatorY, indicatorSize.width, indicatorSize.height);
            CGContextDrawImage(context, indicatorRect, pageIndicatorImage.CGImage);
            baseX += pageIndicatorImage.size.width;
        }
        
        baseX += indicatorSpace;
    }
}

#pragma mark - Accessors

- (void)setCurrentPage:(NSInteger)pageNumber
{
	if (currentPage == pageNumber) return;
	
	currentPage = MIN(MAX(0, pageNumber), numberOfPages - 1);
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numOfPages
{
	numberOfPages = MAX(0, numOfPages);
	currentPage = MIN(MAX(0, currentPage), numberOfPages - 1);
	
	[self setNeedsDisplay];
	
	if (hidesForSinglePage && (numOfPages < 2))
    {
		[self setHidden:YES];
    }
	else
    {
		[self setHidden:NO];
    }
}

- (void)setHidesForSinglePage:(BOOL)hide
{
	hidesForSinglePage = hide;
	
	if (hidesForSinglePage && (numberOfPages < 2))
    {
		[self setHidden: YES];
    }
}

- (void)setPageIndicatorImage:(UIImage *)indicatorImage
{
    if (pageIndicatorImage != indicatorImage)
    {
        [pageIndicatorImage release];
        pageIndicatorImage = [indicatorImage retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setCurrentPageIndicatorImage:(UIImage *)indicatorImage
{
    if (currentPageIndicatorImage != indicatorImage)
    {
        [currentPageIndicatorImage release];
        currentPageIndicatorImage = [indicatorImage retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setIndicatorSpace:(CGFloat)space
{
    if (indicatorSpace != space)
    {
        indicatorSpace = space;

        [self setNeedsDisplay];
    }
}

- (void)reloadUIElements
{
    [pageIndicatorImage release], pageIndicatorImage = nil;
    [currentPageIndicatorImage release], currentPageIndicatorImage = nil;
    
    pageIndicatorImage = [[UIImage skinImageNamed:@"timeline_trend_pagecontrol_point.png"] retain];
    currentPageIndicatorImage = [[UIImage skinImageNamed:@"timeline_trend_pagecontrol_current_point.png"] retain];
    
    [self setNeedsDisplay];
}

@end
