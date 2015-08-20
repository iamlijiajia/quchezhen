//
//  NSString+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 String Handle
 String本身的操作
 */
@interface NSString (Additions)

/**
 判断是否是不可见字符
 */
- (BOOL) isWhitespaceAndNewlines;

/**
 判断是否是空白
 */
- (BOOL) isEmptyOrWhitespace;

/**
 判断是否包含所给子字符串
 substring为空返回YES
 */
- (BOOL) hasSubstring:(NSString*)substring;

/**
 所给字符串之后的String
 substring为空返回自身的Copy
 */
- (NSString*) substringAfterSubstring:(NSString*)substring;

/**
 忽略大小写比较
 Note: -isCaseInsensitiveLike is probably a better alternitive if it's avalible.
 */
- (BOOL) isEqualToStringIgnoringCase:(NSString*)otherString;

/**
 判断所给指针是否为空或者为@“”
 */
+ (BOOL) isEmptyString:(NSString *)string;

/**
 判断是否包含所给字符
 */
- (BOOL) containsCharacterInSet:(NSCharacterSet *)searchSet;

/**
 判断是否包含子字符串
 */
- (BOOL) containsString:(NSString *)searchString options:(NSStringCompareOptions)mask;
- (BOOL) containsString:(NSString *)searchString;

/**
 判断是否以不可见字符开头
 */
- (BOOL) hasLeadingWhitespace;

/**
 移除换行符
 */
- (NSString *)stringByRemovingNewLinesAndWhitespace;

/**
 替换超出长度部分为“...”
 */
- (NSString *) stringWithMaxLength:(NSUInteger)maxLen;

/**
 去掉空白和换行
 */
- (NSString *) trimmedString;

/**
 微博字数统计
 */
- (NSInteger) wordsCount;

/**
 版本比较
 */
- (NSComparisonResult) versionStringCompare:(NSString *)other;

/**
 使用writetofile方法，但是如果给的目录不存在会失败
 此方法保证先建立完整目录再写入数据
 返回保存结果
 */
- (BOOL)saveToFile:(NSString *)path;

/**
 返回MD5值
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 返回SHA1HASH
 */
@property (nonatomic, readonly) NSString* sha1Hash;

@end

/**
 Path Utilities
 文件路径处理辅助方法
 */
@interface NSString (PathUtilities)


- (NSString *)stringByDeletingFirstPathComponent;

- (NSString *)firstPathComponent;

@end

/**
 URL Utilities
 网络请求URL处理辅助方法
 query处理转换
 */
@interface NSString (URLUtils)

/**
 Encoded的URL
 */
- (NSString*) urlEncoded;

/**
 去掉query的URL
 建议使用URLStringWithoutQuery
 */
- (NSString *) urlWithoutParameters;

/**
 去掉query的URL
 */
- (NSString *) URLStringWithoutQuery;

/**
 由Dictionary生成query
 */
+ (NSString *) URLParamstringWithDictionary:(NSDictionary *)dict;


/**
 由query生成dictionary, value为string
 */
- (NSDictionary*)queryDictionaryWithString;

/**
 为URL添加加query
 */
- (NSString*) stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 为URL添加加query（URL Encoded）
 */
- (NSString*) stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;

/**
 保证只encode一次
 */
- (NSString*) stringByAddingPercentEscapesOnce;

/**
 过滤url中敏感信息
 */
+ (NSString *) stringReadableWithURL:(NSURL *)url;

/**
 
 */
- (NSString*) stringByReplacingPercentEscapesOnce;

// e.g. QueryString: param1=value1&param2=value2 , innerGlue:"=" , outterGlue:"&"
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue;

@end

/**
 UUID
 */
@interface NSString (UUID_Pad)
/**
 returns a new string built from a new UUID.
 */
+ (NSString*) stringWithUUID;
@end

/**
 Validation
 判断是否为特定类型
 */
@interface NSString (Validation)

/**
 自定义通配符
 */
- (BOOL) matchRegexp:(NSString *)exp;

/**
 判断是否是国内手机号码（逐步完善）
 */
- (BOOL) isValidatePhoneNumber;

/**
 地址
 */
- (BOOL) isValidateAddress;

/**
 判断是否是邮政编码
 */
- (BOOL) isValidatePostcode;
@end

// Transform (wenhu:与NSTring+Transform冲突)
/*
enum
{
    NSStringTransformFullwidthHalfwidth = 0,
    NSStringTransformHiraganaKatakana,
    NSStringTransformLatinArabic,
    NSStringTransformLatinCyrillic,
    NSStringTransformLatinGreek,
    NSStringTransformLatinHangul,
    NSStringTransformLatinHebrew,
    NSStringTransformLatinHiragana,
    NSStringTransformLatinKatakana,
    NSStringTransformLatinThai,
    NSStringTransformMandarinLatin,
    NSStringTransformStripCombiningMarks,
    NSStringTransformStripDiacritics,
    NSStringTransformToLatin,
    NSStringTransformToUnicodeName,
    NSStringTransformToXMLHex,
    
    // Customized.
    NSStringTransformSimplifiedChineseToTraditional,
    NSStringTransformTraditionalChineseToSimplified,
    NSStringTransformPinyin,                            // Pinyin, No tones, Lowercase, No whitespace.
    NSStringTransformLatinASCII,                        // Latinzation.
};
typedef NSUInteger NSStringTransform;

// 封装CFStringTransform

@interface NSString (Transform)

// [self stringByTransforming:transform range:NSMakeRange(0, self.length) reverse:NO];
- (NSString *)stringByTransforming:(NSStringTransform)transform;

// [self stringByTransforming:transform range:range reverse:NO];
- (NSString *)stringByTransforming:(NSStringTransform)transform
                             range:(NSRange)range;

- (NSString *)stringByTransforming:(NSStringTransform)transform
                             range:(NSRange)range
                           reverse:(BOOL)reverse;

@end
*/

double convertWeiboDate(NSString *time);

@interface NSString (WBiPhoneAddition)
- (NSString *)stringByReplacingRange:(NSRange)aRange with:(NSString *)aString;
- (NSString *)htmlDecodedString;
- (NSString *)htmlEncodedString;

+ (NSString *)firstNonNsNullStringWithString:(NSString*)string, ...;
// e.g. QueryString: param1=value1&param2=value2 , innerGlue:"=" , outterGlue:"&"
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue;
- (NSMutableDictionary *)explodeToDictionaryInnerGlueUTF8Decode:(NSString *)innerGlue outterGlue:(NSString *)outterGlue isCompatibleMode:(BOOL) isCompatibleMode;

@end