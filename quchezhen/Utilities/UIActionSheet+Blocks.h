//
//  UIActionSheet+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIButtonItem.h"
#import <UIKit/UIKit.h>

/**
 为UIActionSheet添加block支持
 传统的UIActionSheet需要代理方法，经常返回的时候很难判断当前的操作和要进行的操作
 这里直接把行为写到对应的title中，更直观和方便
 */
@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

/**
 可能是以前业务需要添加的，暂时想不起了
 weak
 */
@property(nonatomic,assign)id owner;

/**
 cancelButtonItem和destructiveButtonItem可以为空，如果不为空则用系统默认的风格
 */
- (id)initWithTitle:(NSString *)inTitle
   cancelButtonItem:(RIButtonItem *)inCancelButtonItem
destructiveButtonItem:(RIButtonItem *)inDestructiveItem
   otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addButtonItem:(RIButtonItem *)item;

@end
