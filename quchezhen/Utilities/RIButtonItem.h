//
//  RIButtonItem.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RISimpleAction)();

/**
 一个简单的Action-Title的对应，一个项目对用一个block方法
 alertView,actionSheet，tableview或者其他Action-Title对应的地方都能使用
 */
@interface RIButtonItem : NSObject
{
    NSString *label;
    RISimpleAction action;
}
@property (retain, nonatomic)  NSString *label;
@property (copy, nonatomic) RISimpleAction action;
+ (id)item;
+ (id)itemWithLabel:(NSString *)inLabel;
+ (id)itemWithLabel:(NSString *)inLabel action:(RISimpleAction)action;
@end

