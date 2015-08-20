//
//  UIScrollView+Utilities.h
//  MessagesDemo
//
//  Created by Kai on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 UIScrollView设置滚动和位置的扩展方法
 */
@interface UIScrollView (Utilities)

/**
 判断是否滚动到底部
 */
- (BOOL)isScrolledToBottom;
/**
 滚动到底部
 */
- (void)scrollToBottomAnimated:(BOOL)animated;


/**
 判断是否滚动到顶部
 */
- (BOOL)isScrolledToTop;
/**
 滚动到顶部
 */
- (void)scrollToTopAnimated:(BOOL)animated;
@end
