//
//  WBAlertView.h
//  Weibo
//
//  Created by Wade Cheng on 12/31/11.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBAlertViewBasicBlock)(void);
typedef void(^WBAlertViewIndexBlock)(NSInteger index);

@interface WBAlertView : UIAlertView <UIAlertViewDelegate>
{
    id <UIAlertViewDelegate> realDelegate;
    
    WBAlertViewIndexBlock didClickButtonBlock;
    WBAlertViewBasicBlock didCancelBlock;
    WBAlertViewBasicBlock willPresentBlock;
    WBAlertViewBasicBlock didPresentBlock;
    WBAlertViewIndexBlock willDismissWithButtonBlock;
    WBAlertViewIndexBlock didDismissWithButtonBlock;
    
    NSString *safeBlockObjectIdentifier;
    
    id userInfo;
}

@property (nonatomic, copy) WBAlertViewIndexBlock didClickButtonBlock;
@property (nonatomic, copy) WBAlertViewBasicBlock didCancelBlock;
@property (nonatomic, copy) WBAlertViewBasicBlock willPresentBlock;
@property (nonatomic, copy) WBAlertViewBasicBlock didPresentBlock;
@property (nonatomic, copy) WBAlertViewIndexBlock willDismissWithButtonBlock;
@property (nonatomic, copy) WBAlertViewIndexBlock didDismissWithButtonBlock;

@property (nonatomic, retain) NSString *safeBlockObjectIdentifier;

@property (nonatomic, retain) id userInfo;

@property (nonatomic, readonly) UILabel *bodyLabel;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(void))cancelBlock complete:(void (^)(void))completeBlock;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle cancel:(void (^)(void))cancelBlock complete:(void (^)(void))completeBlock;

- (void)clikedButtoAtIndex:(NSInteger)buttonIndex;

@end
