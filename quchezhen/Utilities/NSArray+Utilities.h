//
//  NSArray+Utilities.h
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(JSon)
- (BOOL)writeToJSonFile:(NSString *)path;
@end

/**
 数组中的字符串操作支持
 */
@interface NSArray (StringExtensions)

/**
 取数组中的NSString并排序
 */
- (NSArray *) arrayBySortingStrings;

/**
 判断是否包含所给字符串
 */
- (BOOL)contentString:(NSString *)string;

/**
 返回所给字符串位置（第一个）
 没有返回NSNotFound
 */
- (NSInteger)indexOfString:(NSString *)string;

/**
 arrayBySortingStrings
 */
@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;

/**
 Join With @" "
 */
@property (readonly) NSString *stringValue;
@end

/**
 数组中的字符串操作支持
 */
@interface NSMutableArray (StringExtensions)

/**
 移除所给字符串（ALL）
 */
- (void)removeString:(NSString *)string;

/**
 移除所给字符串（ALL）
 */
- (void)removeStringsInArray:(NSArray *)otherArray;
@end

/**
 数组本身功能辅助方法
 */
@interface NSArray (UtilityExtensions)
/**
 去掉数组里的NSNull
 */
- (NSMutableArray *)clearNullValueForAry:(NSArray *)sourceAry;

/**
 没有返回nil
 */
- (id)firstObject;

/**
 先判断数组的范围再取值
 */
- (id)tryObjectAtIndex:(NSUInteger)index;

/**
 去重
 */
- (NSArray *)uniqueMembers;

/**
 合并数组并去重
 */
- (NSArray *)unionWithArray:(NSArray *)array;

/**
 取两个数组的交集
 */
- (NSArray *)intersectionWithArray:(NSArray *)array;

/**
 取交集
 */
- (NSArray *)intersectionWithSet:(NSSet *)set;

/**
 取非集
 */
- (NSArray *)complementWithArray:(NSArray *)anArray;

/**
 取非集
 */
- (NSArray *)complementWithSet:(NSSet *)anSet;

/**
 使用writetofile方法，但是如果给的目录不存在会失败
 此方法保证先建立完整目录再写入数据
 返回保存结果
 */
- (BOOL)saveToPlistFile:(NSString *)path;
@end

/**
 NSMutableArray辅助方法，待丰富
 */
@interface NSMutableArray (UtilityExtensions)

- (void)addObjectIfNotNil:(id)object;

/**
 Converts a set into an array; actually returns a
 mutable array, if that's relevant to you.
 */
+ (NSMutableArray*) arrayWithSet:(NSSet*)set;
- (void)addObjectIfAbsent:(id)object;
/**
 如果为空则Do Nothing
 */
- (NSMutableArray *) removeFirstObject;

/**
 反序
 */
- (NSMutableArray *) reverse;

/**
 打乱
 */
- (NSMutableArray *) scramble;

- (void)addNullableObject:(id)object;

- (void)addObjectIfNotNil:(id)object;

@property (readonly, getter=reverse) NSMutableArray *reversed;
@end

@interface NSMutableArray (StackAndQueueExtensions)
- (NSMutableArray *)pushObject:(id)object;
- (NSMutableArray *)pushObjects:(id)object,...;
- (id) popObject;
- (id) pullObject;

// Synonyms for traditional use
- (NSMutableArray *)push:(id)object;
- (id) pop;
- (id) pull;

- (void)enqueueObjects:(NSArray *)objects;
@end

@interface NSMutableArray (SetValue)

- (void)addSafeObject:(id)obj;

@end