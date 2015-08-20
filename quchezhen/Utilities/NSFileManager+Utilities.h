//
//  NSFilemanager+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILEMANAGER   [NSFileManager defaultManager]

/**
 Path utilities
 获取常用路径的快捷方法
 */
NSString *NSDocumentsFolder(void);//Documents
NSString *NSLibraryFolder(void);//Library
NSString *NSBundleFolder(void);//BundlePath,iOS下同资源目录
NSString *DocumentFilePath(void);//Documents
NSString *DocumentFileWithName(NSString *name);//Documents下某个文件
NSString *LibraryFilePath(void);//Library
NSString *LibraryFileWithName(NSString *name);//Library下某个文件
NSString *ResourcePath(void);//资源目录
NSString *ResourceWithName(NSString *name);//资源文件
NSString *CacheFilePath(void);//Cache
NSString *CacheFileWithName(NSString *name);
NSString *TempFileWithName(NSString *name);//临时目录

long getDiskFreeSize();//获取剩余磁盘空间，单位：byte

/**
 获取文件目录
 */
@interface NSFileManager(FileExist)
/**
 建立所给路径完整的路径
 */
- (BOOL)buildFolderPath:(NSString *)path error:(NSError **)error;

/**
 获取目录下某个文件的路径，没有返回nil
 */
+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path;

/**
 获取Document目录下某个文件的路径，没有返回nil
 */
+ (NSString *)pathForDocumentNamed:(NSString *)fname;

/**
 获取资源目录下某个文件的路径，没有返回nil
 */
+ (NSString *)pathForBundleDocumentNamed:(NSString *)fname;

/**
 获取所给文件所给Range内容
 */
+ (NSData*)dataOfFile:(NSString*)filePath offset:(unsigned long long)offset length:(unsigned long long)length;

/**
 获取目录下给定扩展名的所有文件的完整路径（不区分大小写）
 */
+ (NSArray *)pathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path;

/**
 获取Document目录下给定扩展名的所有文件的完整路径（不区分大小写）
 */
+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext;

/**
 获取资源目录下给定扩展名的所有文件的完整路径（不区分大小写）
 */
+ (NSArray *)pathsForBundleDocumentsMatchingExtension:(NSString *)ext;

/**
 获取目录下给定所有文件列表（不包含文件夹，只包含文件名）
 */
+ (NSArray *)filesInFolder:(NSString *)path;
@end