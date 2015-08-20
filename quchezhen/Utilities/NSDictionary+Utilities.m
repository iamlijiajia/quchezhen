//
//  NSDictionary+KeyValue.m
//  Weibo
//
//  Created by Kai on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Utilities.h"
#import "NSString+Utilities.h"
#import "NSFileManager+Utilities.h"

#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
	#define CGPointValue pointValue
	#define CGRectValue rectValue
	#define CGSizeValue sizeValue
	#define UIImage NSImage
#else
	#import <UIKit/UIGeometry.h>
	#define NSPointFromString CGPointFromString
	#define NSRectFromString CGRectFromString
	#define NSSizeFromString CGSizeFromString
	#define NSZeroPoint CGPointZero
	#define NSZeroSize CGSizeZero
	#define NSZeroRect CGRectZero
#endif

@implementation NSDictionary (HDKeyValue)

- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
	id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNumber class]])
        return defaultValue;
    return object;
}

- (NSNumber *)numberForKey:(NSString *)key
{
	return [self numberForKey:key defaultValue:nil];
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSString class]])
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            return [object stringValue];
        }
        return defaultValue;
    }
    return object;
}

- (NSString *)dictionaryStringForKey:(NSString *)key;
{
    return [self stringForKey:key defaultValue:nil];
}

- (NSArray *)stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
{
    NSArray *array = [self objectForKey:key];
    if (![array isKindOfClass:[NSArray class]])
        return defaultValue;
    for (id value in array)
    {
        if (![value isKindOfClass:[NSString class]])
            return defaultValue;
    }
    return array;
}

- (NSArray *)stringArrayForKey:(NSString *)key;
{
    return [self stringArrayForKey:key defaultValue:nil];
}

- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;
{
    id value = [self objectForKey:key];
    if (value)
        return [value floatValue];
    return defaultValue;
}

- (float)floatForKey:(NSString *)key;
{
    return [self floatForKey:key defaultValue:0.0f];
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
{
    id value = [self objectForKey:key];
    if (value)
        return [value doubleValue];
    return defaultValue;
}

- (double)doubleForKey:(NSString *)key;
{
    return [self doubleForKey:key defaultValue:0.0];
}

- (CGPoint)pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] && ![NSString isEmptyString:value])
        return NSPointFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGPointValue];
    else
        return defaultValue;
}

- (CGPoint)pointForKey:(NSString *)key;
{
    return [self pointForKey:key defaultValue:NSZeroPoint];
}

- (CGSize)sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] && ![NSString isEmptyString:value])
        return NSSizeFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGSizeValue];
    else
        return defaultValue;
}

- (CGSize)sizeForKey:(NSString *)key;
{
    return [self sizeForKey:key defaultValue:NSZeroSize];
}

- (CGRect)rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] && ![NSString isEmptyString:value])
        return NSRectFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGRectValue];
    else
        return defaultValue;
}

- (CGRect)rectForKey:(NSString *)key;
{
    return [self rectForKey:key defaultValue:NSZeroRect];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
{
    id value = [self objectForKey:key];
	
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        return [value boolValue];
	
    return defaultValue;
}

- (BOOL)boolForKey:(NSString *)key;
{
    return [self boolForKey:key defaultValue:NO];
}

- (unsigned long long int)unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
{
    id value = [self objectForKey:key];
    
    if (value && [value respondsToSelector:@selector(unsignedLongLongValue)])
    {
        return [value unsignedLongLongValue];
    }
    
    return defaultValue;
}

- (unsigned long long int)unsignedLongLongForKey:(NSString *)key;
{
    return [self unsignedLongLongForKey:key defaultValue:0ULL];
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
{
    id value = [self objectForKey:key];
    
    if (value && [value respondsToSelector:@selector(integerValue)])
    {
        return [value integerValue];
    }
    
    return defaultValue;
}

- (NSInteger)integerForKey:(NSString *)key;
{
    return [self integerForKey:key defaultValue:0];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
	id value = [self objectForKey:key];
    
    if (value && [value respondsToSelector:@selector(unsignedIntegerValue)])
    {
        return [value unsignedIntegerValue];
    }
    
    return defaultValue;
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
	return [self unsignedIntegerForKey:key defaultValue:0];
}

- (UIImage *)imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[UIImage class]])
        return defaultValue;
    return object;
}

- (UIImage *)imageForKey:(NSString *)key
{
	return [self imageForKey:key defaultValue:nil];
}

- (UIColor *)UIColorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue
{
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[UIColor class]])
        return defaultValue;
    return object;
}

- (UIColor *)UIColorForKey:(NSString *)key
{
	return [self UIColorForKey:key defaultValue:[UIColor whiteColor]];
}

- (time_t)timeForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    NSString *stringTime = [self objectForKey:key];
    if ((id)stringTime == [NSNull null])
    {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime)
    {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL)
        {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (time_t)timeForKey:(NSString *)key
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self timeForKey:key defaultValue:defaultValue];
}

- (NSDate *)dateForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSince1970:[object intValue]];
    }
    else if ([object isKindOfClass:[NSString class]] && [object length] > 0)
    {
        return [NSDate dateWithTimeIntervalSince1970:[self timeForKey:key]];
    }
    
    return nil;
}

@end


@implementation NSDictionary (HDUtilities)

- (BOOL)saveToPlistFile:(NSString *)path{
    if (![FILEMANAGER buildFolderPath:[path stringByDeletingLastPathComponent] error:NULL])
    {
        return NO;
    }
    return [self writeToFile:path atomically:YES];
}

- (NSMutableDictionary *)clearNullValueForDict:(NSDictionary *)sourceDict
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:sourceDict];
    for (NSString * key in [dict allKeys])
    {
        if ([[dict objectForKey:key] isEqual:[NSNull null]])
        {
            
            [dict removeObjectForKey:key];
            
        }
        if ([[dict objectForKey:key] isKindOfClass:[NSArray class]])
        {
            [dict setObject:[[dict objectForKey:key] clearNullValueForAry:[dict objectForKey:key]] forKey:key];
        }
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]])
        {
            [dict setObject:[[dict objectForKey:key] clearNullValueForDict:[dict objectForKey:key]] forKey:key];
        }
        
        //
        //转储来源 必须保证source字段是一个字符串 并且是href格式
        //
        if([key isEqualToString:@"source"])
        {
            BOOL isValid = FALSE;
            NSString* weiboSourceName = nil;
            NSString* weiboSourceUrl = nil;
            
            //
            //href格式字符串
            //
            if([[dict objectForKey:key] isKindOfClass:[NSString class]])
            {
                weiboSourceUrl = [dict objectForKey:key];
                if([weiboSourceUrl hasSuffix:@"</a>"])
                {
                    NSRange range = [weiboSourceUrl rangeOfString:@"\">"];
                    
                    int location = range.location + 1;
                    int length = weiboSourceUrl.length - location - 5;
                    range.location = location + 1;
                    range.length = length;
                    
                    weiboSourceName = [NSString stringWithFormat:@"%@", [weiboSourceUrl substringWithRange:range]];
                    
                    isValid = YES;
                }
                else
                {
                    weiboSourceName = [dict objectForKey:key];
                    isValid = YES;
                }
            }
            
            //
            // 兼容老接口
            //
            else if([[dict objectForKey:key] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* rowDict = [dict objectForKey:key];
                
                NSString* a = [rowDict objectForKey:@"a"];
                NSString* href = [rowDict objectForKey:@"href"];
                if(nil != a && nil != href)
                {
                    weiboSourceUrl = [NSString stringWithString:href];
                    weiboSourceName = [NSString stringWithString:a];
                    
                    isValid = YES;
                }
            }
            
            if(YES == isValid)
            {
                NSMutableDictionary* sourceDict = [[NSMutableDictionary alloc] initWithDictionary:0];
                [sourceDict setObject:weiboSourceName forKey:@"a"];
                [sourceDict setObject:weiboSourceUrl forKey:@"href"];
                [dict removeObjectForKey:key];
                [dict setValue:sourceDict forKey:@"source"];
                [sourceDict release];
            }
        }
    }
    return dict;
}

@end