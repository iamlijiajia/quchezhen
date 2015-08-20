//
//  NSArray+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-11.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSArray+Utilities.h"
#import "JSONKit.h"
#import <time.h>
#import <stdarg.h>
#import "NSFileManager+Utilities.h"

@implementation NSArray(JSon)
-(BOOL)writeToJSonFile:(NSString *)path
{
    NSString *jsonstring = [self JSONString];
    if (!jsonstring)
    {
        return NO;
    }
    BOOL result = [jsonstring writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    return result;
}
@end

@implementation NSMutableArray(NSStringContent)

- (void)removeString:(NSString *)string
{
    NSInteger index = [self indexOfString:string];
    if (index!=NSNotFound)
    {
        [self removeObjectAtIndex:index];
    }
}

- (void)removeStringsInArray:(NSArray *)otherArray
{
    for (NSString *string in otherArray)
    {
        [self removeString:string];
    }
}
@end


#pragma mark StringExtensions

@implementation NSArray (StringExtensions)

- (NSArray *) arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]])	[sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) stringValue
{
	return [self componentsJoinedByString:@" "];
}

-(BOOL)contentString:(NSString *)string
{
    for (id object in self)
    {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string])
        {
            return YES;
        }
    }
    return NO;
}

-(NSInteger)indexOfString:(NSString *)string
{
    for (id object in self)
    {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string])
        {
            return [self indexOfObject:object];
        }
    }
    return NSNotFound;
}

@end

@implementation NSMutableArray (StringExtensions)

- (void)removeString:(NSString *)string
{
    NSMutableArray *toDelete = [NSMutableArray array];
    for (id object in self)
    {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string])
        {
            [toDelete addObject:object];
        }
    }
    [self removeObjectsInArray:toDelete];
}

- (void)removeStringsInArray:(NSArray *)otherArray
{
    NSMutableArray *toDelete = [NSMutableArray array];
    for (id object in self)
    {
        if ([otherArray contentString:object])
        {
            [toDelete addObject:object];
        }
    }
    [self removeObjectsInArray:toDelete];
}

@end

#pragma mark UtilityExtensions

@implementation NSArray (UtilityExtensions)

- (NSMutableArray *)clearNullValueForAry:(NSArray *)sourceAry
{
    NSMutableArray * ary = [NSMutableArray arrayWithArray:sourceAry];
    for (int i = 0;i<[ary count];i++)
    {
        id object = [ary objectAtIndex:i];
        if ([object isKindOfClass:[NSDictionary class]])
        {
            [ary replaceObjectAtIndex:i withObject:[object clearNullValueForDict:object]];
        }
        if ([object isEqual:[NSNull null]])
        {
            [ary replaceObjectAtIndex:i withObject:@""];
        }
    }
    return ary;
}
- (id)firstObject {
	if ([self count] == 0)
		return nil;
	return [self objectAtIndex:0];
}

- (id)tryObjectAtIndex:(NSUInteger)index{
    if (self.count > index)
    {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSArray *) uniqueMembers
{
	NSMutableArray *copy = [[self mutableCopy] autorelease];
	for (id object in self)
	{
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
	return copy;
}

- (NSArray *) unionWithArray: (NSArray *) anArray
{
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSArray *)intersectionWithArray:(NSArray *)anArray
{
	NSMutableArray *copy = [[self mutableCopy] autorelease];
	for (id object in self)
		if (![anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

- (NSArray *)intersectionWithSet:(NSSet *)anSet
{
	NSMutableArray *copy = [[self mutableCopy] autorelease];
	for (id object in self)
		if (![anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

// http://en.wikipedia.org/wiki/Complement_(set_theory)
- (NSArray *)complementWithArray:(NSArray *)anArray
{
	NSMutableArray *copy = [[self mutableCopy] autorelease];
	for (id object in self)
		if ([anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

- (NSArray *)complementWithSet:(NSSet *)anSet
{
	NSMutableArray *copy = [[self mutableCopy] autorelease];
	for (id object in self)
		if ([anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

- (BOOL)saveToPlistFile:(NSString *)path{
    if (![FILEMANAGER buildFolderPath:[path stringByDeletingLastPathComponent] error:NULL]) {
        return NO;
    }
    return [self writeToFile:path atomically:YES];
}
@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UtilityExtensions)

- (void)addNullableObject:(id)object
{
	if (object == nil)
	{
		[self addObject:[NSNull null]];
	}
	else
	{
		[self addObject:object];
	}
}

- (void)addObjectIfNotNil:(id)object
{
    if (object)
    {
        [self addObject:object];
    }
}

+ (NSMutableArray*) arrayWithSet:(NSSet*)set
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[set count]];
	[set enumerateObjectsUsingBlock:^(id obj, BOOL *stop)
    {
		[array addObject:obj];
	}];
	return array;
}

- (void)addObjectIfAbsent:(id)object
{
	if (object == nil || [self containsObject:object])
	{
		return;
	}
	
	[self addObject:object];
}

- (NSMutableArray *) reverse
{
	for (int i=0; i<(floor([self count]/2.0)); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *) scramble
{
	for (int i=0; i<([self count]-2); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:(i+(random()%([self count]-i)))];
	return self;
}

- (NSMutableArray *) removeFirstObject
{
    if (self.count > 0) {
     	[self removeObjectAtIndex:0];
    }
	return self;
}

@end


#pragma mark StackAndQueueExtensions

@implementation NSMutableArray (StackAndQueueExtensions)

- (id) popObject
{
	if ([self count] == 0) return nil;
	
    id lastObject = [[[self lastObject] retain] autorelease];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) pushObject:(id)object
{
    [self addObject:object];
	return self;
}

- (NSMutableArray *) pushObjects:(id)object,...
{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do
	{
		[self addObject:obj];
		obj = va_arg(objects, id);
	} while (obj);
	va_end(objects);
	return self;
}

- (id) pullObject
{
	if ([self count] == 0) return nil;
	
	id firstObject = [[[self objectAtIndex:0] retain] autorelease];
	[self removeObjectAtIndex:0];
	return firstObject;
}

- (NSMutableArray *)push:(id)object
{
	return [self pushObject:object];
}

- (id) pop
{
	return [self popObject];
}

- (id) pull
{
	return [self pullObject];
}

- (void)enqueueObjects:(NSArray *)objects
{
	for (id object in [objects reverseObjectEnumerator])
    {
		[self insertObject:object atIndex:0];
	}
}

@end

@implementation NSMutableArray (SetValue)

- (void)addSafeObject:(id)obj
{
    if (obj == nil)
        return;
    
    [self addObject:obj];
    
}

@end