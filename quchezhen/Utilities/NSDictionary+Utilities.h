//
//  NSDictionary+KeyValue.h
//  Weibo
//
//  Created by Kai on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
	#import <Foundation/NSGeometry.h> // For NSPoint, NSSize, and NSRect
	#import <AppKit/AppKit.h>
#else
	#import <CoreGraphics/CGGeometry.h>
	#import <UIKit/UIKit.h>
#endif

/**
 添加本身功能的快捷方式等
 为NSDictionary添加直接的类型判断和操作，或者默认返回值，如果没有给定key的值则返回默认值
 */
@interface NSDictionary (HDKeyValue)

/**
 NSNumber操作
 */
- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)numberForKey:(NSString *)key;

/**
 NSString操作
 */
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSString *)dictionaryStringForKey:(NSString *)key;

/**
 NSArray操作
 */
- (NSArray *)stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSArray *)stringArrayForKey:(NSString *)key;

/** ObjC methods to nil have undefined results for non-id values (though ints happen to currently work)
 简单数据类型
 */
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (double)doubleForKey:(NSString *)key;

- (CGPoint)pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue;
- (CGPoint)pointForKey:(NSString *)key;
- (CGSize)sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
- (CGSize)sizeForKey:(NSString *)key;
- (CGRect)rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
- (CGRect)rectForKey:(NSString *)key;

/** Returns YES iff the value is YES, Y, yes, y, or 1.
 
 Just to make life easier
 */
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (BOOL)boolForKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (NSInteger)integerForKey:(NSString *)key;

- (NSUInteger)unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

- (unsigned long long int)unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
- (unsigned long long int)unsignedLongLongForKey:(NSString *)key;

/**
 返回UIImage
 */
- (UIImage *)imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue;
- (UIImage *)imageForKey:(NSString *)key;

/** 
 Originally colorForKey:defaultValue:, colorForKey:.
 BaiduInput has the same names.
 */
- (UIColor *)UIColorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue;
- (UIColor *)UIColorForKey:(NSString *)key;

/**
 时间相关
 */
- (time_t)timeForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (time_t)timeForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;

@end

/**
 添加扩展功能
 */
@interface NSDictionary (HDUtilities)
/**
 可能会常常用到writetofile方法，但是如果给的目录不存在会失败，此方法保证先建立完整目录再写入数据
 */
- (BOOL)saveToPlistFile:(NSString *)path;
/**
 去掉字典里的NSNull
 */
- (NSMutableDictionary *)clearNullValueForDict:(NSDictionary *)sourceDict;
@end
