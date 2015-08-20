//
//  WBLikeButton.h
//  Weibo
//
//  Created by wu yusheng on 12-11-6.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "WBPageCard.h"

@protocol WBLikeButtonDelegate;


typedef enum
{
    WBLikeStateUnknown           = 0,
    WBLikeStateLike              = 1,
    WBLikeStateUnLike            = 2,
    WBLikeStatePicUnknown        = 3,
    WBLikeStatePicLike           = 4,
    WBLikeStatePicUnLike         = 5,
} WBLikeState;

@interface WBLikeButton : UIButton
{
    WBLikeState likeState;
    UIButton * likeImageButton;
    UIImage * likeImage;
    UIImage * unLikeImage;
}

@property (nonatomic, assign) id<WBLikeButtonDelegate> delegate;
@property (nonatomic, assign) WBLikeState likeState;
@property (nonatomic, retain) UIImage *likeImage;
@property (nonatomic, retain) UIImage *unLikeImage;
@property (nonatomic, retain) UIImage *likeStateHighlightedImage;
@property (nonatomic, retain) UIImage *unLikeStateHighlightedImage;
@property (nonatomic, assign) BOOL adjustsLikeImageWhenHighlighted;
@property (nonatomic, readonly) BOOL isAnimating;

@property (nonatomic, assign) BOOL animating;

- (void)beginLikeAnimation;
- (void)updateBackgroundImageWithState:(WBLikeState) newLikeState;
- (void)setLikeState:(WBLikeState)newLikeState animated:(BOOL)animate;
- (void)setLikeStateImage:(UIImage *)likeStateImage andUnLikeStateImage:(UIImage *)unLikeStateImage;
- (void)setHighlightedLikeStateImage:(UIImage *)likeStateHighlightedImage unLikeStateImage:(UIImage *)unLikeStateHighlightedImage;
// method for subclass override (must call super!)
- (void)buttonDidBecomeLargestDuringAnimation;
- (void)resetLikeImageButton;

@end

@protocol WBLikeButtonDelegate <NSObject>

- (void)likeButton:(WBLikeButton *)button didFinishAnimationSuccessed:(BOOL)successed;

@end

