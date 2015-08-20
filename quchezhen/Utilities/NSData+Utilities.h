//
//  NSData+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonHMAC.h>

/**
 添加各种编码支持
 MD5
 SHA1
 BASE64
 */
@interface NSData (HashUtilities)

@property (nonatomic, readonly) NSString* md5Hash;

@property (nonatomic, readonly) NSString* sha1Hash;

+ (id)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;

- (NSString *)hmacWithAlgo:(CCHmacAlgorithm)algo key:(NSString *)key;
@end

@interface NSData (Utilities)
/**
 使用writetofile方法，但是如果给的目录不存在会失败
 此方法保证先建立完整目录再写入数据
 返回保存结果
 */
- (BOOL)saveToFile:(NSString *)path;
@end