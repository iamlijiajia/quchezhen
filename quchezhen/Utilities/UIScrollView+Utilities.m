//
//  UIScrollView+Utilities.m
//  MessagesDemo
//
//  Created by Kai on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIScrollView+Utilities.h"


@implementation UIScrollView (Utilities)

- (BOOL)isScrolledToBottom
{
	if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height)
	{
		return YES;
	}

	return NO;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
	CGRect rect = CGRectMake(self.contentOffset.x, self.contentSize.height - 1, self.contentSize.width, 1);
	[self scrollRectToVisible:rect animated:animated];
}

- (BOOL)isScrolledToTop
{
	return self.contentOffset.y <= 0;
}

- (void)scrollToTopAnimated:(BOOL)animated
{
	CGRect rect = CGRectMake(self.contentOffset.x, -1, self.contentSize.width, 1);
	[self scrollRectToVisible:rect animated:animated];
}
@end