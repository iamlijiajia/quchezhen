//
//  NSDate+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSDate+Utilities.h"


#define SUNDAY_STR       NSLocalizedString(@"Sunday", @"Sunday")
#define MONDAY_STR       NSLocalizedString(@"Monday", @"Monday")
#define TUESDAY_STR      NSLocalizedString(@"Tuesday", @"Tuesday")
#define WEDNESDAY_STR    NSLocalizedString(@"Wednesday", @"Wednesday")
#define THURSDAY_STR     NSLocalizedString(@"Thursday", @"Thursday")
#define FRIDAY_STR       NSLocalizedString(@"Friday", @"Friday")
#define SATURDAY_STR     NSLocalizedString(@"Saturday", @"Saturday")

#define JUST_NOW_STR     NSLocalizedString(@"Just Now", @"Just Now")
#define SECONDS_AGO_STR  NSLocalizedString(@"%d seconds ago",@"")
#define MINUTES_AGO_STR  NSLocalizedString(@"%d minutes ago", @"")
#define HOURS_AGO_STR    NSLocalizedString(@"%d hours ago", @"")
#define DAYS_AGO_STR     NSLocalizedString(@"%d days ago", @"")
#define WEEKS_AGO_STR    NSLocalizedString(@"%d weeks ago", @"")

//临时方案，懒得改那么多代码
#define loadMuLanguage(a , b)   a

@implementation NSDate(Additions)

- (NSString *)wb_formattedStringForMessageBoxDetailList
{
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSDayCalendarUnit;
	
	NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	NSString *timeStr = nil;
	
	if ([components year] >= 1)
	{
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
	}
	else if ([components day] > 1)
	{
		[dateFormatter setDateFormat:@"MM-dd HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
	}
	else if ([components day] == 1)
	{
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ %@", loadMuLanguage(@"昨天", nil), @"HH:mm"]];
		timeStr = [dateFormatter stringFromDate:self];
	}
	else
	{
		[dateFormatter setDateFormat:@"HH:mm"];
        timeStr = [dateFormatter stringFromDate:self];
	}
	
    [dateFormatter release];
	[calendar release];
	
    return timeStr;
}

+ (NSString *) timeStringWithInterval:(NSTimeInterval)time
{
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1)
    {//avoid 0 seconds
        string = JUST_NOW_STR;
    }
    else if (distance < 60)
    {
        string = [NSString stringWithFormat:SECONDS_AGO_STR, (distance)];
    }
    else if (distance < 3600)
    {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:MINUTES_AGO_STR,(distance)];
    }
    else if (distance < 86400)
    {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:HOURS_AGO_STR, (distance)];
    }
    else if (distance < 604800)
    {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:DAYS_AGO_STR, (distance)];
    }
    else if (distance < 2419200)
    {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:WEEKS_AGO_STR,(distance)];
    }
    else
    {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        [dateFormatter release];
        
    }
    return string;
}

+ (NSString *)descriptionFromNow:(NSString *)time
{
    NSString *string;
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [format setLocale:cnLocale];
    [cnLocale release];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSDate *dateTime = [format dateFromString:time];
    [format release];

    NSTimeInterval dd =[dateTime timeIntervalSinceReferenceDate];
    NSDate* createdAt = [NSDate dateWithTimeIntervalSinceReferenceDate:dd];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *createdAtComponents = [calendar components:unitFlags fromDate:createdAt];

    if([nowComponents year] == [createdAtComponents year] &&
       [nowComponents month] == [createdAtComponents month] &&
       [nowComponents day] == [createdAtComponents day])
    {
        //今天
        NSInteger distance = [createdAt timeIntervalSinceNow];
        if (distance < 0 && distance > -60*60)
        {
            //一小时内
            int min = -distance/60;
            if (min == 0)
            {
                min = 1;
            }
            if (min > 1)
            {
                string = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前s",@""),min];
            }
            else
            {
                string = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前",@""),min];
            }
        }
        else
        {
            [dateFormatter setDateFormat:loadMuLanguage(@"'今天'HH:mm",@"")];
            string = [dateFormatter stringFromDate:createdAt];

        }
    }
    else if ([nowComponents year] == [createdAtComponents year])
    {
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [cnLocale release];
        [dateFormatter setDateFormat:loadMuLanguage(@"MM-dd HH:mm",@"")];
        string = [dateFormatter stringFromDate:createdAt];
    }
    else
    {
        //去年
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [cnLocale release];
        [dateFormatter setDateFormat:loadMuLanguage(@"yyyy-MM-dd' 'HH:mm",@"")];
        string = [dateFormatter stringFromDate:createdAt];
    }
    [calendar release];
    [dateFormatter release];
    return string;    
}

- (NSString *)descriptionFromNow
{
    NSString *string;
    NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *createdAtComponents = [calendar components:unitFlags fromDate:self];
    if([nowComponents year] == [createdAtComponents year] &&
       [nowComponents month] == [createdAtComponents month] &&
       [nowComponents day] == [createdAtComponents day])
    {
        //今天
        NSInteger distance = -[self timeIntervalSinceNow];
        if (distance >= 0 && distance < 60*60)
        {
            //一小时内
            int min = distance/60;
            if (min == 0)
            {
                min = 1;
            }
            if (min > 1)
            {
                string = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前s",@""),min];
            }
            else
            {
                string = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前",@""),min];
            }
        }
        else
        {
            [dateFormatter setDateFormat:loadMuLanguage(@"'今天'HH:mm",@"")];
            string = [dateFormatter stringFromDate:self];
            
        }
    }
    else if ([nowComponents year] == [createdAtComponents year])
    {
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [cnLocale release];
        [dateFormatter setDateFormat:loadMuLanguage(@"MM-dd HH:mm",@"")];
        string = [dateFormatter stringFromDate:self];
    }
    else
    {
        //去年
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:cnLocale];
        [cnLocale release];
        [dateFormatter setDateFormat:loadMuLanguage(@"yyyy-MM-dd' 'HH:mm",@"")];
        string = [dateFormatter stringFromDate:self];
    }
    [calendar release];
    [dateFormatter release];
    return string;
}

+ (NSString *)timeIntervalString
{
    return [NSString stringWithFormat:@"%i",(int)[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)stringWithSeperator:(NSString *)seperator
{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	[formatter release];
	return date;
}

- (NSString *)stringWithFormat:(NSString*)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	[formatter release];
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear
{
	if( seperator==nil )
    {
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear )
    {
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}
    else
    {
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	[formatter release];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero.
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero.
- (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

- (NSString *)weekday{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:self] integerValue];
	if( weekday==1 )
    {
		weekdayStr = SUNDAY_STR;
	}
    else if( weekday==2 )
    {
		weekdayStr = MONDAY_STR;
	}
    else if( weekday==3 )
    {
		weekdayStr = TUESDAY_STR;
	}
    else if( weekday==4 )
    {
		weekdayStr = WEDNESDAY_STR;
	}
    else if( weekday==5 )
    {
		weekdayStr = THURSDAY_STR;
	}
    else if( weekday==6 )
    {
		weekdayStr = FRIDAY_STR;
	}
    else if( weekday==7 )
    {
		weekdayStr = SATURDAY_STR;
	}
	[formatter release];
	return weekdayStr;
}

+ (NSDate *)dateWithLocalNaturalLanguageString:(NSString *)timeString
{
	time_t timestamp;
	
	struct tm created;
    time_t now;
    time(&now);
    
	if (timeString)
	{
		if (strptime([timeString UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL)
		{
			strptime([timeString UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		
		timestamp = mktime(&created);
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
		return date;
	}
	
	return nil;
}

- (NSString *)wb_briefRelativeFormattedString
{
	NSCalendar* calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
	
	NSString *timeStr = nil;
	
	if ([components day] >= 7)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d周前", nil), 1];
	}
	else if ([components day] > 1)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d天s前", nil), [components day]];
	}
	else if ([components day] == 1)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d天前", nil), [components day]];
	}
	else if ([components hour] > 1)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d小时s前", nil), [components hour]];
	}
	else if ([components hour] == 1)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d小时前", nil), [components hour]];
	}
	else if ([components minute] > 1)
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d分钟s前", nil), [components minute]];
	}
	else
	{
		timeStr = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", nil), 1];
	}
	
	[calendar release];
	
    return timeStr;
}

- (NSString *)wb_generalRelativeFormattedString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    // 当前可能在多个异步线程同时执行本方法
    // 但 NSDateFormatter 是线程不安全的，暂时先不使用共享的formatter
    // http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html#//apple_ref/doc/uid/10000057i-CH12-122647-BBCCEGFF
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //	static NSDateFormatter *dateFormatter = nil;
    //
    //	if (dateFormatter == nil)
    //	{
    //		dateFormatter = [[NSDateFormatter alloc] init];
    //	}
    
	NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
	NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(-24*60*60)]];
    
	[calendar release];
	
	NSString *formattedString = nil;
	if ([nowComponents year] == [dateComponents year] &&
	    [nowComponents month] == [dateComponents month] &&
	    [nowComponents day] == [dateComponents day])				// 今天.
	{
		
		int diff = [self timeIntervalSinceNow];
        
		if (diff <= 0 && diff > -60 * 60)							// 一小时之内.
		{
			int min = -diff / 60;
			
			if (min == 0)
			{
				min = 1;
			}
            
			if (min <= 1)
			{
				formattedString = [NSString stringWithFormat:loadMuLanguage(@"刚刚", @""), min];
			}
			else
			{
				formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟s前", @""), min];
			}
		}
		else if (diff > 0)
		{
			formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", @""), 1];
		}
		else
		{
            int hour = -diff/3600;
			formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d小时前", @""), hour];
		}
	}
    else if([yesterdayComponents year] == [dateComponents year] &&
            [yesterdayComponents month] == [dateComponents month] &&
            [yesterdayComponents day] == [dateComponents day])
    {
        formattedString = loadMuLanguage(@"昨天", @"");
    }
	else
	{
		NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
		[dateFormatter setLocale:mainlandChinaLocale];
		[mainlandChinaLocale release];
		
		if ([nowComponents year] == [dateComponents year])
		{
			[dateFormatter setDateFormat:@"MM-dd"];
		}
		else
		{
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		}
		
		formattedString = [dateFormatter stringFromDate:self];
	}
    
    return formattedString;
    
}

- (NSString *)wb_relativeFormattedString
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    // 当前可能在多个异步线程同时执行本方法
    // 但 NSDateFormatter 是线程不安全的，暂时先不使用共享的formatter
    // http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html#//apple_ref/doc/uid/10000057i-CH12-122647-BBCCEGFF
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //	static NSDateFormatter *dateFormatter = nil;
    //
    //	if (dateFormatter == nil)
    //	{
    //		dateFormatter = [[NSDateFormatter alloc] init];
    //	}
    
	NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
	
	[calendar release];
	
	NSString *formattedString = nil;
	if ([nowComponents year] == [dateComponents year] &&
	    [nowComponents month] == [dateComponents month] &&
	    [nowComponents day] == [dateComponents day])				// 今天.
	{
		
		int diff = [self timeIntervalSinceNow];
        
		if (diff <= 0 && diff > -60 * 60)							// 一小时之内.
		{
			int min = -diff / 60;
			
			if (min == 0)
			{
				min = 1;
			}
            
			if (min <= 1)
			{
				formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", @""), min];
			}
			else
			{
				formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟s前", @""), min];
			}
		}
		else if (diff > 0)
		{
			formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", @""), 1];
		}
		else
		{
			[dateFormatter setDateFormat:loadMuLanguage(@"'今天 'HH:mm", @"")];
            
			formattedString = [dateFormatter stringFromDate:self];
		}
	}
	else
	{
		NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
		[dateFormatter setLocale:mainlandChinaLocale];
		[mainlandChinaLocale release];
		
		if ([nowComponents year] == [dateComponents year])
		{
			[dateFormatter setDateFormat:@"MM-dd' 'HH:mm"];
		}
		else
		{
			[dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
		}
		
		formattedString = [dateFormatter stringFromDate:self];
	}
    
	return formattedString;
}

- (NSString *)wb_readableRelativeFormattedString
{
    // TODO: Multi-Lang Support
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
	
	[calendar release];
	
	NSString *formattedString = nil;
	if ([nowComponents year] == [dateComponents year] &&
	    [nowComponents month] == [dateComponents month] &&
	    [nowComponents day] == [dateComponents day])				// 今天.
	{
		
		int diff = [self timeIntervalSinceNow];
        
		if (diff <= 0 && diff > -60 * 60)							// 一小时之内.
		{
			int min = -diff / 60;
			if (min == 0) min = 1;
			if (min <= 1) formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", @""), min];
			else formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟s前", @""), min];
		}
		else if (diff > 0)
		{
			formattedString = [NSString stringWithFormat:loadMuLanguage(@"%d分钟前", @""), 1];
		}
		else
		{
			[dateFormatter setDateFormat:loadMuLanguage(@"'今天 'HH点mm分", @"")];
			formattedString = [dateFormatter stringFromDate:self];
		}
	}
	else
	{
		NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
		[dateFormatter setLocale:mainlandChinaLocale];
		[mainlandChinaLocale release];
		if ([nowComponents year] == [dateComponents year])
		{
			[dateFormatter setDateFormat:loadMuLanguage(@"MM月dd日' 'HH点mm分", @"")];
		}
		else
		{
			[dateFormatter setDateFormat:loadMuLanguage(@"yyyy年MM月dd日' 'HH点mm分", @"")];
		}
		formattedString = [dateFormatter stringFromDate:self];
	}
	return formattedString;
}

- (NSString *)wb_dateTimeString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    [calendar release];
    
    NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:mainlandChinaLocale];
    [mainlandChinaLocale release];
    
    if ([nowComponents year] == [dateComponents year] &&
	    [nowComponents month] == [dateComponents month] &&
	    [nowComponents day] == [dateComponents day])
    {
        // 若为今天，不显示日期，只显示时间
        [formatter setDateFormat:@"HH:mm"];
    }
    else
    {
        [formatter setDateFormat:@"MM-dd' 'HH:mm"];
    }
    NSString * formatedString = [formatter stringFromDate:self];
    [formatter release];
    return formatedString;
}

- (NSString *)stringWithFormatter:(NSString *)formatterString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    
    //    NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    [formatter setLocale:mainlandChinaLocale];
    //    [mainlandChinaLocale release];
    
    NSString * formatedString = [formatter stringFromDate:self];
    [formatter release];
    return formatedString;
}

@end