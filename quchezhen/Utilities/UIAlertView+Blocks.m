//
//  UIAlertView+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  BUGFixed by Stephen Liu on 12/3/20.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";

@implementation UIAlertView (Blocks)

- (id)initWithTitle:(NSString *)inTitle
            message:(NSString *)inMessage
   cancelButtonItem:(RIButtonItem *)inCancelButtonItem
   otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if((self = [self initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inCancelButtonItem.label otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(RIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inCancelButtonItem) [buttonsArray insertObject:inCancelButtonItem atIndex:0];
        
        objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setDelegate:self];
        [self retain]; // keep yourself around!
    }
    return self;
}

- (void)addButtonItem:(RIButtonItem *)item
{
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);
	
	[self addButtonWithTitle:item.label];
	[buttonsArray addObject:item];
	
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    NSArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);
//    RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
//    if(item.action)
//        item.action();
//    objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self release]; // and release yourself!
//}

//fix crash when the system redisplay an alertview after blocking.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);
    RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
    if(item.action)
        item.action();
    objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self release]; // and release yourself!
    self.delegate = nil;
}
@end

#define CANCEL_STR           @"取消"
#define OK_STR               @"确定"
@implementation UIAlertView(Additions)

+ (UIAlertView *) alertWithDelegate:(id)delegate
                              title:(NSString *)title
                            message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:OK_STR
                                          otherButtonTitles:nil];
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView *) alertWithDelegate:(id)delegate
                              title:(NSString *)title
                            message:(NSString *)msg
                             cancel:(NSString *)cancel
                             others:(NSString *)others, ...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:others,nil];
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView *) alertWithTitle:(NSString *)inTitle
                         message:(NSString *)inMessage
                cancelButtonItem:(RIButtonItem *)inCancelButtonItem
                otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:inTitle
                                                    message:inMessage
                                           cancelButtonItem:inCancelButtonItem
                                           otherButtonItems:inOtherButtonItems,nil];
    [alert show];
    return [alert autorelease];
}

+ (UIAlertView *) alertWithTitle:(NSString *)inTitle
                         message:(NSString *)inMessage
                    cancelAction:(RISimpleAction)cancelAction
                    commitAction:(RISimpleAction)commitAction
{
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:CANCEL_STR];
    [cancel setAction:cancelAction];
    
    RIButtonItem *ok = [RIButtonItem itemWithLabel:OK_STR];
    [ok setAction:commitAction];
    
    return [UIAlertView  alertWithTitle:inTitle
                                message:inMessage
                       cancelButtonItem:cancel
                       otherButtonItems:ok,nil];
}
@end
