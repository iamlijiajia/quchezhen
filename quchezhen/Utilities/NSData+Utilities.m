//
//  NSData+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSData+Utilities.h"
#import "NSFileManager+Utilities.h"

// Standard library
#include <stdint.h>
#include <stdio.h>

// Core Foundation
#include <CoreFoundation/CoreFoundation.h>

// Cryptography
#include <CommonCrypto/CommonDigest.h>

@implementation NSData (HashUtilities)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], [self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], [self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// base64 code found on http://www.cocoadev.com/index.pl?BaseSixtyFour
// where the poster released it to public domain
// style not exactly congruous with normal three20 style, but kept mostly intact with the original
static const char encodingTable[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSData*)dataWithBase64EncodedString:(NSString *)string
{
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)base64Encoding
{
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [self length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        // Encode the bytes in the buffer to four characters,
        // including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters
                                           length:length
                                         encoding:NSASCIIStringEncoding
                                     freeWhenDone:YES]
            autorelease];
}
// end recycled base64 code
///////////////////////////////////////////////////////////////////////////////////////////////////


- (NSString *)hmacWithAlgo:(CCHmacAlgorithm)algo key:(NSString *)key
{
	
	const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
	const char *cData = [self bytes];
	
	
	unsigned int digest_len;
	
	switch (algo)
    {
			
		case kCCHmacAlgSHA1:
			digest_len = CC_SHA1_DIGEST_LENGTH;
			break;
		case kCCHmacAlgMD5:
			digest_len = CC_MD5_DIGEST_LENGTH;
			break;
		case kCCHmacAlgSHA256:
			digest_len = CC_SHA256_DIGEST_LENGTH;
			break;
		case kCCHmacAlgSHA384:
			digest_len = CC_SHA384_DIGEST_LENGTH;
			break;
		case kCCHmacAlgSHA512:
			digest_len = CC_SHA512_DIGEST_LENGTH;
			break;
		case kCCHmacAlgSHA224:
			digest_len = CC_SHA224_DIGEST_LENGTH;
			break;
	}
	
	unsigned char cHMAC[digest_len];
	
	CCHmac(algo, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	
	
	char hash[2 * sizeof(cHMAC) + 1];
    for (size_t i = 0; i < sizeof(cHMAC); ++i)
    {
        snprintf(hash + (2 * i), 3, "%02x", (int)(cHMAC[i]));
    }
	
	return [NSString stringWithUTF8String:hash];
	
}
@end

@implementation NSData (Utilities)

- (BOOL)saveToFile:(NSString *)path
{
    if (![FILEMANAGER buildFolderPath:[path stringByDeletingLastPathComponent] error:NULL])
    {
        return NO;
    }
    return [self writeToFile:path atomically:YES];
}
@end