//
//  NSFilemanager+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSFilemanager+Utilities.h"

#define FileHashDefaultChunkSizeForReadingData 4096

NSString *NSDocumentsFolder(void)
{
	static NSString *documentFolder = nil;
	if (documentFolder == nil)
    {
		documentFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] retain];
	}
	return documentFolder;
}

NSString *NSLibraryFolder(void)
{
	static NSString *libraryFolder = nil;
	if (libraryFolder == nil)
    {
		libraryFolder = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] retain];
	}
	return libraryFolder;
}

NSString *NSBundleFolder(void)
{
	return [[NSBundle mainBundle] bundlePath];
}

NSString *TempFileWithName(NSString *name)
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:name];
}

NSString *DocumentFilePath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

NSString *DocumentFileWithName(NSString *name)
{
    return [DocumentFilePath() stringByAppendingPathComponent:name];
}

NSString *LibraryFilePath(void)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

NSString *LibraryFileWithName(NSString *name)
{
    return [LibraryFilePath() stringByAppendingPathComponent:name];
}

NSString *ResourcePath(void)
{
	return [[NSBundle mainBundle] resourcePath];
}

NSString *ResourceWithName(NSString *name)
{
    return [ResourcePath() stringByAppendingPathComponent:name];
}

NSString *CacheFilePath()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
    return cacheFolder;
}

NSString *CacheFileWithName(NSString *name)
{
    return [CacheFilePath() stringByAppendingPathComponent:name];
}

long getDiskFreeSize()
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    id obj = [fattributes objectForKey:NSFileSystemFreeSize];
    if ([obj respondsToSelector:@selector(longValue)])
    {
        return [obj longValue];
    }
    return -1;
}

@implementation NSFileManager(FileExist)

- (BOOL)buildFolderPath:(NSString *)path error:(NSError **)error
{
    BOOL isDirectory = NO;
    BOOL exists = [FILEMANAGER fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists)
    {
        if (!isDirectory)
        {
            [FILEMANAGER removeItemAtPath:path error:NULL];
            return [FILEMANAGER createDirectoryAtPath:path
                          withIntermediateDirectories:NO
                                           attributes:nil
                                                error:error];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        NSString *parent = [path stringByDeletingLastPathComponent];
        if ([self buildFolderPath:parent error:error])
        {
            return [FILEMANAGER createDirectoryAtPath:path
                          withIntermediateDirectories:NO
                                           attributes:nil
                                                error:error];
        }
    }
    return NO;
}

+ (NSData*)dataOfFile:(NSString*)filePath offset:(unsigned long long)offset length:(unsigned long long)length
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) return nil;
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *stat = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (error != nil) return nil;
    
    unsigned long long totalLength = [stat fileSize];
    
    if (length <= 0 || offset + length > totalLength)
    {
        length = totalLength - offset;
    }
    
//    NSLog(@"1filePath = %@", filePath);
//    NSLog(@"1offset = %lli", offset);
//    NSLog(@"1length = %lli", length);
//    NSLog(@"1totalLength = %lli", totalLength);
    
    [fileHandle seekToFileOffset:offset];
    return [fileHandle readDataOfLength:length];
}

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path
{
    NSString *itemPath = [path stringByAppendingPathComponent:fname];
    if (![FILEMANAGER fileExistsAtPath:itemPath])
    {
        return nil;
    }
    return itemPath;
    
    
	NSString *file = nil;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while ((file = [dirEnum nextObject]))
    {
		if ([[file lastPathComponent] isEqualToString:fname])
        {
			return [path stringByAppendingPathComponent:file];
        }
    }
	return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while ((file = [dirEnum nextObject]))
	{
		BOOL isDir;
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir)
        {
            [results addObject:file];
        }
	}
	return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while ((file = [dirEnum nextObject]))
    {
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
        {
			[results addObject:[path stringByAppendingPathComponent:file]];
        }
    }
	return results;
}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}
@end
