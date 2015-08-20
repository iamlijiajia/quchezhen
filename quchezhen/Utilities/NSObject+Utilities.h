//
//  NSObject+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNSObjectPropertyName;
extern NSString *const NSObjectPropertyUnknowName;
extern NSString *const kNSObjectPropertyType;
extern NSString *const NSObjectPropertyUnknowType;

@interface NSObject (PropertyAccess)
+ (NSDictionary *)properties;
+ (NSDictionary *)ivars;
+ (Class)classWithPropertyType:(NSString *)propertyType;
@end
