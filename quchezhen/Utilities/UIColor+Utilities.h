//
//  UIColor+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 UIColor快速生成方式
 */

//0-255
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

//0-255
#ifndef RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

//0-255
#ifndef RGBA
#define RGBA(r,g,b,a) r/255.0, g/255.0, b/255.0, a
#endif

//0-1
#define FLOATRGBCOLOR(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]
#define FLOATRGBCGCOLOR(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1].CGColor

#define FLOATRGBACOLOR(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define FLOATRGBACGCOLOR(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a].CGColor


UIColor *UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue);
UIColor *UIColorMakeRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

@interface UIColor (Utilities)

@end
