//
//  BMob+SafeObject.m
//  quchezhen
//
//  Created by lijiajia on 15/8/26.
//  Copyright (c) 2015年 lijiajia. All rights reserved.
//

#import "BMob+SafeObject.h"

@implementation BmobObject(SafeObject)

- (void)setSafeObject:(id)obj forKey:(NSString *)aKey
{
    if (!aKey || [aKey isEqualToString:@""])
    {
        return;
    }
    
    if (obj)
    {
        [self setObject:obj forKey:aKey];
    }
    else
    {
        [self setObject:@"" forKey:aKey];
    }
}

@end
