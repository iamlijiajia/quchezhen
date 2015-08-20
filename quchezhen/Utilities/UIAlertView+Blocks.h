//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIButtonItem.h"
#import <UIKit/UIKit.h>


/**
 为UIAlertView添加block支持
 block会被retain
 传统的UIAlertView需要代理方法，经常返回的时候很难判断当前的操作和要进行的操作
 这里直接把行为写到对应的title中，更直观和方便
 */
@interface UIAlertView (Blocks)

/**
 cancelButtonItem可以为空，如果不为空则用系统默认的风格
 */
- (id)initWithTitle:(NSString *)inTitle 
            message:(NSString *)inMessage 
   cancelButtonItem:(RIButtonItem *)inCancelButtonItem 
   otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addButtonItem:(RIButtonItem *)item;

@end

/**
 添加弹出alert的快捷方法，直接show
 返回autoRelease对象
 */
@interface  UIAlertView(Additions)
+ (UIAlertView *) alertWithDelegate:(id)delegate
                              title:(NSString *)title
                            message:(NSString *)msg;

+ (UIAlertView *) alertWithDelegate:(id)delegate
                              title:(NSString *)title
                            message:(NSString *)msg
                             cancel:(NSString *)cancel
                             others:(NSString *)others, ...;

+ (UIAlertView *) alertWithTitle:(NSString *)inTitle
                         message:(NSString *)inMessage
                cancelButtonItem:(RIButtonItem *)inCancelButtonItem
                otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...;

+ (UIAlertView *) alertWithTitle:(NSString *)inTitle
                         message:(NSString *)inMessage
                    cancelAction:(RISimpleAction)cancelAction
                    commitAction:(RISimpleAction)commitAction;
@end
