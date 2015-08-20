//
//  UIButton+Blocks.h
//
//  Created by 诗彬 刘 on 12-3-21.
//  Copyright (c) 2012年 Stephen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^UIControlBlock)(UIControl *button);

/**
 为UIControl添加block支持，常用的有UIButton
 block会被retain
 */
@interface UIControl(Blocks)
- (void)addActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event;
- (void)setActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event;
@end
