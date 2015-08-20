//
//  NSString+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSString+Utilities.h"
#import "NSData+Utilities.h"
#import "NSFileManager+Utilities.h"


static inline BOOL IsEmpty(id thing)
{
	return thing == nil ||
	([thing isEqual:[NSNull null]]) ||
	([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
	([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

double convertWeiboDate(NSString *time)
{
    struct tm tm;
    time_t t;
    time = [time substringFromIndex:4];
    strptime([time cStringUsingEncoding:NSUTF8StringEncoding], "%b %d %H:%M:%S %z %Y", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    
    return [date timeIntervalSince1970];
}

#pragma mark String Handle
@implementation NSString (Additions)

- (BOOL)isWhitespaceAndNewlines
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i)
    {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Deprecated - https://github.com/facebook/three20/issues/367
 */
- (BOOL)isEmptyOrWhitespace
{
    // A nil or NULL string is not the same as an empty string
    return 0 == self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

// Returns YES if the string is nil or equal to @""
+ (BOOL)isEmptyString:(NSString *)string;
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    return string == nil || [string isEqualToString:@""];
}

- (BOOL)containsCharacterInSet:(NSCharacterSet *)searchSet;
{
    NSRange characterRange = [self rangeOfCharacterFromSet:searchSet];
    return characterRange.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)searchString options:(NSStringCompareOptions)mask;
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString options:mask].location != NSNotFound;
}

- (BOOL)containsString:(NSString *)searchString;
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString].location != NSNotFound;
}

- (BOOL)hasLeadingWhitespace;
{
    if ([self length] == 0)
		return NO;
    switch ([self characterAtIndex:0])
    {
        case ' ':
        case '\t':
        case '\r':
        case '\n':
            return YES;
        default:
            return NO;
    }
}

//移除换行符
- (NSString *)stringByRemovingNewLinesAndWhitespace
{
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Strange New lines:
    //  Next Line, U+0085
    //  Form Feed, U+000C
    //  Line Separator, U+2028
    //  Paragraph Separator, U+2029
    
    // Scanner
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *temp;
    NSCharacterSet *newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // Scan
    while (![scanner isAtEnd]) {
        
        // Get non new line or whitespace characters
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // Replace with a space
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@" "];
        }
    }
    
    // Cleanup
    [scanner release];
    
    // Return
    NSString *retString = [[NSString stringWithString:result] retain];
    [result release];
    
    // Drain
    [pool drain];
    
    // Return
    return [retString autorelease];
    
}

- (BOOL) hasSubstring:(NSString*)substring;
{
	if(IsEmpty(substring)) return YES;
	NSRange substringRange = [self rangeOfString:substring];
	return substringRange.location != NSNotFound && substringRange.length > 0;
}

- (NSString*) substringAfterSubstring:(NSString*)substring;
{
    if (IsEmpty(substring)) return [self copy];
	if ([self hasSubstring:substring]) return [self substringFromIndex:NSMaxRange([self rangeOfString:substring])];
	return nil;
}

//Note: -isCaseInsensitiveLike should work when avalible!
- (BOOL) isEqualToStringIgnoringCase:(NSString*)otherString;
{
	if(!otherString)
		return NO;
	return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch + NSWidthInsensitiveSearch];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other
{
    NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
    NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
    
    // The parts before the "a"
    NSString *oneMain = [oneComponents objectAtIndex:0];
    NSString *twoMain = [twoComponents objectAtIndex:0];
    
    // If main parts are different, return that result, regardless of alpha part
    NSComparisonResult mainDiff;
    if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame)
    {
        return mainDiff;
    }
    
    // At this point the main parts are the same; just deal with alpha stuff
    // If one has an alpha part and the other doesn't, the one without is newer
    if ([oneComponents count] < [twoComponents count])
    {
        return NSOrderedDescending;
        
    }
    else if ([oneComponents count] > [twoComponents count])
    {
        return NSOrderedAscending;
        
    }
    else if ([oneComponents count] == 1)
    {
        // Neither has an alpha part, and we know the main parts are the same
        return NSOrderedSame;
    }
    
    // At this point the main parts are the same and both have alpha parts. Compare the alpha parts
    // numerically. If it's not a valid number (including empty string) it's treated as zero.
    NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
    NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
    return [oneAlpha compare:twoAlpha];
}

- (NSString *)stringWithMaxLength:(NSUInteger)maxLen
{
    NSUInteger length = [self length];
    if (length <= maxLen || length <= 3)
    {
        return self;
    }
    else
    {
        return [NSString stringWithFormat:@"%@...", [self substringToIndex:maxLen - 3]];
    }
}

- (NSString *)trimmedString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (int)wordsCount
{
	// Source: http://www.cocoachina.com/macdev/cocoa/2011/0110/2552.html
	int i, n = [self length], l = 0, a = 0, b = 0;
    
	unichar c;
    
	for (i = 0; i < n; i++)
	{
		c = [self characterAtIndex:i];
        
		if (isblank(c))
		{
			b++;
		}
		else if (isascii(c))
		{
			a++;
		}
		else
		{
			l++;
		}
	}
    
	if (a == 0 && l == 0)
	{
		return 0;
	}
    
	return l + (int)ceilf((float)(a + b) / 2.0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

- (BOOL)saveToFile:(NSString *)path{
    if (![FILEMANAGER buildFolderPath:[path stringByDeletingLastPathComponent] error:NULL])
    {
        return NO;
    }
    return [self writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
@end

#pragma mark Path Utilities
@implementation NSString (PathUtilities)

- (NSString *)stringByDeletingFirstPathComponent
{
    NSMutableArray *components = [NSMutableArray arrayWithArray:[self pathComponents]];
    [components removeString:@"/"];
    if (components.count)
    {
        [components removeObjectAtIndex:0];
    }
    return [components componentsJoinedByString:@"/"];
}

- (NSString *)firstPathComponent
{
    NSMutableArray *components = [NSMutableArray arrayWithArray:[self pathComponents]];
    [components removeString:@"/"];
    if (components.count > 0)
    {
        return [components objectAtIndex:0];
    }
    return nil;
}

@end

#pragma mark URL Utilities
@implementation NSString (URLUtils)

- (NSString *)urlWithoutParameters
{
    NSRange r;
    NSString *newUrl;
    
    r = [self rangeOfString:@"?" options: NSBackwardsSearch];
    if (r.length > 0)
        newUrl = [self substringToIndex: NSMaxRange (r) - 1];
    else
        newUrl = self;
    
    return newUrl;
}



- (NSDictionary*)queryDictionaryWithString
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[[NSScanner alloc] initWithString:self] autorelease];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [kvPair objectAtIndex:0];
            NSString* value = [kvPair objectAtIndex:1];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query
{
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator])
    {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound)
    {
        return [self stringByAppendingFormat:@"?%@", params];
    }
    else
    {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

+ (NSString *)URLParamstringWithDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [dict keyEnumerator])
    {
        if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
        {
            continue;
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", [key urlEncoded], [[dict objectForKey:key] urlEncoded]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}


- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query
{
    NSMutableDictionary* encodedQuery = [NSMutableDictionary dictionaryWithCapacity:[query count]];
    
    for (NSString* key in [query keyEnumerator])
    {
        NSParameterAssert([key respondsToSelector:@selector(urlEncoded)]);
        NSString* value = [query objectForKey:key];
        NSParameterAssert([value respondsToSelector:@selector(urlEncoded)]);
        value = [value urlEncoded];
        key = [key urlEncoded];
        [encodedQuery setValue:value forKey:key];
    }
    
    return [self stringByAddingQueryDictionary:encodedQuery];
}


- (id)urlEncoded
{
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString *)URLStringWithoutQuery
{
    NSArray *parts = [self componentsSeparatedByString:@"?"];
    return [parts objectAtIndex:0];
}

- (NSString*) stringByReplacingPercentEscapesOnce;
{
	NSString *unescaped = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//self may be a string that looks like an invalidly escaped string,
	//eg @"100%", in that case it clearly wasn't escaped,
	//so we return it as our unescaped string.
	return unescaped ? unescaped : self;
}

- (NSString*) stringByAddingPercentEscapesOnce;
{
	return [[self stringByReplacingPercentEscapesOnce] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *) stringReadableWithURL:(NSURL *)url
{
    NSString *absoluteString = [url absoluteString];
    NSString *oldQuery = [url query];
    
//    NSMutableDictionary *params = [[[url query] queryDictionaryWithStringUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSMutableDictionary *params = [[[url query] queryDictionaryWithString] mutableCopy];
    [params removeObjectForKey:@"gsid"];
    NSString *newQuery = [@"" stringByAddingQueryDictionary:params];
    if ([newQuery hasPrefix:@"?"])
    {
        newQuery = [newQuery substringFromIndex:1];
    }
    [params release];
    
    if (oldQuery && newQuery)
    {
        absoluteString = [absoluteString stringByReplacingOccurrencesOfString:oldQuery withString:newQuery];
    }
    
    return absoluteString;
}

/*
 * source: http://stackoverflow.com/questions/1967399/parse-nsurl-path-and-query-iphoneos
 */
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue {
    // Explode based on outter glue
    NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
    NSArray *secondExplode;
    
    // Explode based on inner glue
    NSInteger count = [firstExplode count];
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        secondExplode = [(NSString *)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
        if ([secondExplode count] == 2) {
            [returnDictionary setObject:[secondExplode objectAtIndex:1] forKey:[secondExplode objectAtIndex:0]];
        }
    }
    
    return returnDictionary;
}

@end

#pragma UUID
@implementation NSString (UUID_Pad)

+ (NSString*)stringWithUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}

@end

@implementation NSString (Validation)

- (BOOL) matchRegexp:(NSString *)exp
{
    NSPredicate *expTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp];
    return [expTest evaluateWithObject:self];
}

- (BOOL) isValidatePhoneNumber
{
	NSString *phoneNumberRegex = @"\\+?[0-9]+\\-?[0-9]+#?";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    if (![phoneNumberTest evaluateWithObject:self])
    {
        return NO;
    }
    
    if ([self length] != 11)
    {
        return NO;
    }
    
    if ([self hasPrefix:@"13"]|[self hasPrefix:@"15"]||[self hasPrefix:@"18"])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL) isValidateAddress
{
    if([self length] > 60 || [self length] < 5) {
        return NO;
    }
    
    return YES;
}

- (BOOL) isValidatePostcode
{
    if (!self || [self length] != 6)
    {
        return NO;
    }
    return [self matchRegexp:@"\\+?[0-9]+\\-?[0-9]"];
}
@end

/*
@implementation NSString (Transform)

- (NSString *)stringByTransforming:(NSStringTransform)transform
{
    return [self stringByTransforming:transform range:NSMakeRange(0, self.length) reverse:NO];
}

- (NSString *)stringByTransforming:(NSStringTransform)transform
                             range:(NSRange)range
{
    return [self stringByTransforming:transform range:range reverse:NO];
}

- (NSString *)stringByTransforming:(NSStringTransform)transform
                             range:(NSRange)range
                           reverse:(BOOL)reverse
{
    static CFStringRef Transforms[NSStringTransformLatinASCII + 1];
    
    if (!Transforms[0])
    {
        Transforms[NSStringTransformFullwidthHalfwidth]  = kCFStringTransformFullwidthHalfwidth;
        Transforms[NSStringTransformHiraganaKatakana]    = kCFStringTransformHiraganaKatakana;
        Transforms[NSStringTransformLatinArabic]         = kCFStringTransformLatinArabic;
        Transforms[NSStringTransformLatinCyrillic]       = kCFStringTransformLatinCyrillic;
        Transforms[NSStringTransformLatinGreek]          = kCFStringTransformLatinGreek;
        Transforms[NSStringTransformLatinHangul]         = kCFStringTransformLatinHangul;
        Transforms[NSStringTransformLatinHebrew]         = kCFStringTransformLatinHebrew;
        Transforms[NSStringTransformLatinHiragana]       = kCFStringTransformLatinHiragana;
        Transforms[NSStringTransformLatinKatakana]       = kCFStringTransformLatinKatakana;
        Transforms[NSStringTransformLatinThai]           = kCFStringTransformLatinThai;
        Transforms[NSStringTransformMandarinLatin]       = kCFStringTransformMandarinLatin;
        Transforms[NSStringTransformStripCombiningMarks] = kCFStringTransformStripCombiningMarks;
        Transforms[NSStringTransformStripDiacritics]     = kCFStringTransformStripDiacritics;
        Transforms[NSStringTransformToLatin]             = kCFStringTransformToLatin;
        Transforms[NSStringTransformToUnicodeName]       = kCFStringTransformToUnicodeName;
        Transforms[NSStringTransformToXMLHex]            = kCFStringTransformToXMLHex;
        Transforms[NSStringTransformSimplifiedChineseToTraditional] = CFSTR("Simplified - Traditional");
        Transforms[NSStringTransformTraditionalChineseToSimplified] = CFSTR("Traditional - Simplified");
        Transforms[NSStringTransformPinyin]              = CFSTR("Any - Latin; NFD; [:Nonspacing Mark:] Remove; [:Whitespace:] Remove; Lower; NFC;");
        Transforms[NSStringTransformLatinASCII]          = CFSTR("Any - Latin; NFD; [:Nonspacing Mark:] Remove; [:Whitespace:] Remove; Lower; NFC;");
    }
    
    NSMutableString *tmpString = [[self mutableCopy] autorelease];
    CFRange tmpRange = CFRangeMake(range.location, range.length);
    
    if (CFStringTransform((CFMutableStringRef)tmpString, &tmpRange, Transforms[transform], reverse))
    {
        return tmpString;
    }
    
    return self;
}
@end
*/

@implementation NSString (WBiPhoneAddition)

- (NSString *)stringByReplacingRange:(NSRange)aRange with:(NSString *)aString {
    unsigned int bufferSize;
    unsigned int selfLen = [self length];
    unsigned int aStringLen = [aString length];
    unichar *buffer;
    NSRange localRange;
    NSString *result;
    
    bufferSize = selfLen + aStringLen - aRange.length;
    buffer = NSAllocateMemoryPages(bufferSize*sizeof(unichar));
    
    /* Get first part into buffer */
    localRange.location = 0;
    localRange.length = aRange.location;
    [self getCharacters:buffer range:localRange];
    
    /* Get middle part into buffer */
    localRange.location = 0;
    localRange.length = aStringLen;
    [aString getCharacters:(buffer+aRange.location) range:localRange];
    
    /* Get last part into buffer */
    localRange.location = aRange.location + aRange.length;
    localRange.length = selfLen - localRange.location;
    [self getCharacters:(buffer+aRange.location+aStringLen) range:localRange];
    
    /* Build output string */
    result = [NSString stringWithCharacters:buffer length:bufferSize];
    
    NSDeallocateMemoryPages(buffer, bufferSize);
    
    return result;
}

- (NSString *)htmlDecodedString
{
	NSMutableString *temp = [NSMutableString stringWithString:self];
	
	[temp replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [temp length])];
	
	return [NSString stringWithString:temp];
}

- (NSString *)htmlEncodedString
{
	NSMutableString *temp = [NSMutableString stringWithString:self];
	
	[temp replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"'" withString:@"&apos;" options:0 range:NSMakeRange(0, [temp length])];
	
	return [NSString stringWithString:temp];
}


+ (NSString *)firstNonNsNullStringWithString:(NSString*)string, ...
{
    NSString* result = nil;
    
    id arg = nil;
    va_list argList;
    
    if (string && [string isKindOfClass:[NSString class]])
    {
        return string;
    }
    
    va_start(argList, string);
    while ((arg = va_arg(argList, id)))
    {
        if (arg && [arg isKindOfClass:[NSString class]])
        {
            result = arg;
            break;
        }
    }
    va_end(argList);
    
    
    return result;
}

/*
 * source: http://stackoverflow.com/questions/1967399/parse-nsurl-path-and-query-iphoneos
 */
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue {
    // Explode based on outter glue
    NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
    NSArray *secondExplode;
    
    // Explode based on inner glue
    NSInteger count = [firstExplode count];
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        secondExplode = [(NSString *)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
        if ([secondExplode count] == 2) {
            [returnDictionary setObject:[secondExplode objectAtIndex:1] forKey:[secondExplode objectAtIndex:0]];
        }
    }
    
    return returnDictionary;
}


- (NSMutableDictionary *)explodeToDictionaryInnerGlueUTF8Decode:(NSString *)innerGlue outterGlue:(NSString *)outterGlue isCompatibleMode:(BOOL) isCompatibleMode
{
    NSMutableDictionary *srcDictionary = [self explodeToDictionaryInnerGlue:innerGlue outterGlue:outterGlue];
    
    NSEnumerator* keyEnum = [srcDictionary keyEnumerator];
    NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionary];
    id key = nil;
    NSString* src = nil;
    NSString* dec = nil;
    while (key = [keyEnum nextObject])
    {
        src = [srcDictionary objectForKey:key];
        if ([src isKindOfClass:[NSString class]])
        {
            if (isCompatibleMode)
            {
                src = [src stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
            }
            dec = [src stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([dec length] > 0)
            {
                src = dec;
            }
        }
        if (key && [key lowercaseString])
        {
            [returnDictionary setObject:src forKey:[key lowercaseString]];
        }
    }
    
    return returnDictionary;
}
@end
