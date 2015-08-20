//
//  RIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem
@synthesize label;
@synthesize action;

+ (id)item
{
    return [[self new] autorelease];
}

+ (id)itemWithLabel:(NSString *)inLabel
{
    id newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

+ (id)itemWithLabel:(NSString *)inLabel action:(RISimpleAction)action
{
    RIButtonItem *newItem = [self itemWithLabel:inLabel];
    [newItem setAction:action];
    return newItem;
}

- (void)dealloc
{
    self.label = nil;
    self.action = nil;
    [super dealloc];
}
@end

