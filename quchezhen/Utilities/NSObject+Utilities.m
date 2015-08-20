//
//  NSObject+Utilities.m
//  WeiboHDPro
//
//  Created by Stephen Liu on 12-10-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "NSObject+Utilities.h"
#import "RegexKitLite.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kNSObjectPropertyName = @"kNSObjectPropertyName";
NSString *const NSObjectPropertyUnknowName = @"__NSObjectPropertyUnknowName__";
NSString *const kNSObjectPropertyType = @"kNSObjectPropertyType";
NSString *const NSObjectPropertyUnknowType = @"__NSObjectPropertyUnknowType__";

static const char *getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T'){
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
    }
    return "@";
}

@implementation NSObject (PropertyAccess)

+ (NSDictionary *)properties
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    if (outCount <= 0)
    {
        free(properties);
        return nil;
    }
    NSMutableDictionary *ps = [NSMutableDictionary dictionary];
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
            NSString *propertyType = [NSString stringWithCString:propType encoding:NSASCIIStringEncoding];
            if (!propertyName)
            {
                propertyName = NSObjectPropertyUnknowName;
            }
            if (!propertyType)
            {
                propertyType = NSObjectPropertyUnknowType;
            }
            [ps setObject:propertyType forKey:propertyName];//addObject:@{kNSObjectPropertyName:propertyName,kNSObjectPropertyType:propertyType}];
        }
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:ps];
}

+ (NSDictionary *)ivars
{
    unsigned int varCount, i;
    Ivar *vars = class_copyIvarList(self, &varCount);
    if (varCount <= 0)
    {
        free(vars);
        return nil;
    }
    NSMutableDictionary *vs = [NSMutableDictionary dictionary];
    for(i = 0; i < varCount; i++)
    {
        Ivar var = vars[i];
        const char *vName = ivar_getName(var);
        if(vName) {
            const char *vType = ivar_getTypeEncoding(var);
            NSString *ivarName = [NSString stringWithCString:vName encoding:NSASCIIStringEncoding];
            NSString *ivarType = [NSString stringWithCString:vType encoding:NSASCIIStringEncoding];
//            ivarType = [ivarType stringByReplacingOccurrencesOfRegex:@"[^\\w]" withString:@""];
            if (!ivarName)
            {
                ivarName = NSObjectPropertyUnknowName;
            }
            if (!ivarType)
            {
                ivarType = NSObjectPropertyUnknowType;
            }
            [vs setObject:ivarType forKey:ivarName];
        }
    }
    free(vars);
    return [NSDictionary dictionaryWithDictionary:vs];
}

+ (Class)classWithPropertyType:(NSString *)propertyType{
    if(![propertyType hasPrefix:@"@\""])
        return nil;
    NSString *ivarType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length-3)];
    return NSClassFromString(ivarType);
}
@end
