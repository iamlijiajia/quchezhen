//
//  WBAlertView.m
//  Weibo
//
//  Created by Wade Cheng on 12/31/11.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import "WBAlertView.h"
#import "NSObject+SafeBlock.h"

@implementation WBAlertView

@synthesize didClickButtonBlock;
@synthesize didCancelBlock;
@synthesize willPresentBlock;
@synthesize didPresentBlock;
@synthesize willDismissWithButtonBlock;
@synthesize didDismissWithButtonBlock;
@synthesize safeBlockObjectIdentifier;
@synthesize userInfo;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(void))cancelBlock complete:(void (^)(void))completeBlock
{
    [self alertWithTitle:title
                 message:message
             cancelTitle:@"取消"
                 okTitle:@"确定"
                  cancel:cancelBlock
                complete:completeBlock];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle cancel:(void (^)(void))cancelBlock complete:(void (^)(void))completeBlock
{
    WBAlertView *alert = [[WBAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:okTitle, nil];
    NSInteger otherButtonIndex = alert.firstOtherButtonIndex;
    [alert setDidClickButtonBlock:^(NSInteger index) {
        if (index == otherButtonIndex)
        {
            if (completeBlock) completeBlock();
        }
        else
        {
            if (cancelBlock) cancelBlock();
        }
    }];
    [alert show];
    [alert release];
}

#pragma mark - Delegate

- (void)setDelegate:(id <UIAlertViewDelegate>)delegate
{
    [super setDelegate:self];
    realDelegate = delegate;
}

- (id <UIAlertViewDelegate>)delegate
{
    return realDelegate;
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [realDelegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    
    if (didClickButtonBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        didClickButtonBlock(buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(alertViewCancel:)])
    {
        [realDelegate alertViewCancel:self];
    }
    
    if (didCancelBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        didCancelBlock();
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(willPresentAlertView:)])
    {
        [realDelegate willPresentAlertView:self];
    }
    
    if (willPresentBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        willPresentBlock();
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(didPresentAlertView:)])
    {
        [realDelegate didPresentAlertView:self];
    }
    
    if (didPresentBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        didPresentBlock();
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
    {
        [realDelegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if (willDismissWithButtonBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        willDismissWithButtonBlock(buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (realDelegate && [realDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
    {
        [realDelegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
    
    if (didDismissWithButtonBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        didDismissWithButtonBlock(buttonIndex);
    }
}

- (void)clikedButtoAtIndex:(NSInteger)buttonIndex
{
    if (didDismissWithButtonBlock && is_safe_block_object_still_alive(safeBlockObjectIdentifier))
    {
        didDismissWithButtonBlock(buttonIndex);
    }
}

#pragma mark - Properties

- (UILabel *)bodyLabel
{
    // We're going to get the private bodayTextLabel here.
    return [self valueForKey:[@"body" stringByAppendingString:@"TextLabel"]];
}

#pragma mark - Memory Management

- (void)dealloc
{
    [didClickButtonBlock release], didClickButtonBlock = nil;
    [didCancelBlock release], didCancelBlock = nil;
    [willPresentBlock release], willPresentBlock = nil;
    [didPresentBlock release], didPresentBlock = nil;
    [willDismissWithButtonBlock release], willDismissWithButtonBlock = nil;
    [didDismissWithButtonBlock release], didDismissWithButtonBlock = nil;
    [safeBlockObjectIdentifier release], safeBlockObjectIdentifier = nil;
	[userInfo release], userInfo = nil;
	
    [super dealloc];
}

@end
