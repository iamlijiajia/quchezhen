//
//  NSDate+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 NSDate生成、转换和快捷方法
 */
@interface NSDate(Additions)

/**
 自然语言表示距现在的时间（需要添加LocalizedString，待确定）
 */
+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;

+ (NSString *)descriptionFromNow:(NSString *)time;

- (NSString *)descriptionFromNow;

/**
 timeIntervalSince1970
 */
+ (NSString *)timeIntervalString;

/**
 自然语言转NSDate
 */
+ (NSDate *)dateWithLocalNaturalLanguageString:(NSString *)timeString;

/**
 自定义formate，具体formate参见http://msdn.microsoft.com/en-us/library/8kb3ddd4.aspx
 */
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
- (NSString *)stringWithFormat:(NSString*)format;

/**
 仅包含年月日
 */
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;

/**
 [self stringWithSeperator:seperator includeYear:YES];
 */
- (NSString *)stringWithSeperator:(NSString *)seperator;

/**
 return the date by given the interval day by today. interval can be positive, negtive or zero.
 天为单位
 */
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;

- (NSDate *)relativedDateWithInterval:(NSInteger)interval;

/**
 返回星期
 */
- (NSString *)weekday;



- (NSString *)wb_relativeFormattedString;
- (NSString *)wb_generalRelativeFormattedString;

- (NSString *)wb_briefRelativeFormattedString;
- (NSString *)wb_dateTimeString;

- (NSString *)wb_readableRelativeFormattedString;

- (NSString *)stringWithFormatter:(NSString *)formatterString;

- (NSString *)wb_formattedStringForMessageBoxDetailList;

@end