//
//  config.h
//  quchezhen
//
//  Created by lijiajia on 15/8/13.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#ifndef quchezhen_config_h
#define quchezhen_config_h


#define CurrentAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]


#define KWeiXin     @"微信"
#define KWeibo      @"微博"
#define KQQ         @"QQ"

#define RGB_Color(r,g,b)    RGBA_Color(r,g,b,1)
#define RGBA_Color(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255 blue:b/255.0 alpha:a])

#define URL(a)  [NSURL URLWithString:[a stringByAppendingString:@"?t=1&a=c1e1b5577d1666c6251dd727f07224bc"]]

#define KTopOffset  64

#define kKeyAppVersionStr  @"V1.0.1"
#define kKeyAppVersionNum   10100

#define KServiceTel     @"010-85746992"

#define KDebugEnable    0

#endif
