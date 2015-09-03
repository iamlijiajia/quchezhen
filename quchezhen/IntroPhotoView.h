//
//  IntroPhotoView.h
//  quchezhen
//
//  Created by lijiajia on 15/7/13.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPhotoView : UIView <UIScrollViewDelegate>

- (id)initWithImages:(NSArray*)images andFrame:(CGRect)frame;
- (id)initWithImageNames:(NSArray*)nameStrings andFrame:(CGRect)frame;

- (id)initWithImages:(NSArray*)images Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame;
- (id)initWithImageNames:(NSArray*)imageNames Discriptions:(NSArray *)discriptions andFrame:(CGRect)frame;

- (void)stretchOffset:(CGFloat)offset;

@end
