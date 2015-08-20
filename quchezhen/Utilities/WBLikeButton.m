//
//  WBLikeButton.m
//  Weibo
//
//  Created by wu yusheng on 12-11-6.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "WBLikeButton.h"
#import "UIView+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@interface WBLikeButton ()
@end

@implementation WBLikeButton
@synthesize likeState;
@synthesize likeImage;
@synthesize unLikeImage;
@synthesize delegate = _delegate;
@synthesize animating = _animating;

-(void) dealloc
{
    [likeImage release], likeImage = nil;
    [unLikeImage release], unLikeImage = nil;
	[_likeStateHighlightedImage release], _likeStateHighlightedImage = nil;
	[_unLikeStateHighlightedImage release], _unLikeStateHighlightedImage = nil;
    [likeImageButton release], likeImageButton = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
        self.animating = NO;
        
		//likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        likeImageButton = [[UIButton alloc] init];
        likeImageButton.userInteractionEnabled = NO;
        likeImageButton.adjustsImageWhenHighlighted = NO;
        
        self.isAccessibilityElement = NO;
        likeImageButton.isAccessibilityElement = NO;
        
        [self addSubview:likeImageButton];
	}
	
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    likeImageButton.centerX = floorf(self.width / 2);
    likeImageButton.centerY = floorf(self.height / 2);
}

- (void)setLikeStateImage:(UIImage *)likeStateImage andUnLikeStateImage:(UIImage *)unLikeStateImage
{
    self.likeImage = likeStateImage;
    self.unLikeImage = unLikeStateImage;
    
    [self resetLikeImageButton];
}

- (void)setHighlightedLikeStateImage:(UIImage *)likeStateHighlightedImage unLikeStateImage:(UIImage *)unLikeStateHighlightedImage
{
	self.likeStateHighlightedImage = likeStateHighlightedImage;
	self.unLikeStateHighlightedImage = unLikeStateHighlightedImage;
	
	[self resetLikeImageButton];
}

- (void)resetLikeImageButton
{
    switch (likeState)
    {
        case WBLikeStateLike:
            
            [likeImageButton setBackgroundImage:self.likeImage forState:UIControlStateNormal];
			if (self.likeStateHighlightedImage) {
				[likeImageButton setBackgroundImage:self.likeStateHighlightedImage forState:UIControlStateHighlighted];
			}
            [likeImageButton sizeToFit];
            self.hidden = NO;
            break;
            
        case WBLikeStateUnLike:
            
            [likeImageButton setBackgroundImage:self.unLikeImage forState:UIControlStateNormal];
			if (self.unLikeStateHighlightedImage) {
				[likeImageButton setBackgroundImage:self.unLikeStateHighlightedImage forState:UIControlStateHighlighted];
			}
            [likeImageButton sizeToFit];
            self.hidden = NO;
            break;
            
        case WBLikeStateUnknown:
            self.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)setLikeState:(WBLikeState)newLikeState
{
    [self setLikeState:newLikeState animated:NO];
}

- (void)setLikeState:(WBLikeState)newLikeState animated:(BOOL)animate
{
    BOOL likeStateChanged = !(likeState == newLikeState);
    likeState = newLikeState;
    
    [self resetLikeImageButton];
    
    if (likeStateChanged && animate)
    {
        [self beginLikeAnimation];
    }
    
    NSString * key = (newLikeState == WBLikeStateLike) ? @"已赞" : @"未赞";
    self.accessibilityValue = key;
}

- (void)buttonDidBecomeLargestDuringAnimation
{
    if (likeState == WBLikeStateLike)
    {
        [likeImageButton setBackgroundImage:self.likeImage forState:UIControlStateNormal];
		if (self.likeStateHighlightedImage) {
			[likeImageButton setBackgroundImage:self.likeStateHighlightedImage forState:UIControlStateHighlighted];
		}
    }
    else
    {
        [likeImageButton setBackgroundImage:self.unLikeImage forState:UIControlStateNormal];
		if (self.unLikeStateHighlightedImage) {
			[likeImageButton setBackgroundImage:self.unLikeStateHighlightedImage forState:UIControlStateHighlighted];
		}
    }
}

- (void)beginLikeAnimation
{
    [self bringSubviewToFront:likeImageButton];
    
    if (likeState == WBLikeStateLike)
    {
        [likeImageButton setBackgroundImage:self.unLikeImage forState:UIControlStateNormal];
		if (self.unLikeStateHighlightedImage) {
			[likeImageButton setBackgroundImage:self.unLikeStateHighlightedImage forState:UIControlStateHighlighted];
		}
    }
    else
    {
        [likeImageButton setBackgroundImage:self.likeImage forState:UIControlStateNormal];
		if (self.likeStateHighlightedImage) {
			[likeImageButton setBackgroundImage:self.likeStateHighlightedImage forState:UIControlStateHighlighted];
		}
    }
    
    self.animating = YES;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        likeImageButton.layer.transform = CATransform3DMakeScale(2.0, 2.0, 1.0);
        
    } completion:^(BOOL finished) {
        
        if (!finished) {
            return ;
        }
        
        [self buttonDidBecomeLargestDuringAnimation];
        
        likeImageButton.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.40;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        
        self.animating = YES;
        
        [likeImageButton.layer addAnimation:animation forKey:nil];
    }];
    
}

- (void)updateBackgroundImageWithState:(WBLikeState) newLikeState
{
    likeState = newLikeState;
    [self resetLikeImageButton];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        self.animating = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeButton:didFinishAnimationSuccessed:)])
    {
        [self.delegate likeButton:self didFinishAnimationSuccessed:flag];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [likeImageButton setHighlighted:highlighted];
}

- (void)setAdjustsLikeImageWhenHighlighted:(BOOL)adjustsLikeImageWhenHighlighted
{
    likeImageButton.adjustsImageWhenHighlighted = adjustsLikeImageWhenHighlighted;
}

- (BOOL)adjustsLikeImageWhenHighlighted
{
    return likeImageButton.adjustsImageWhenHighlighted;
}

- (BOOL)isAnimating
{
    return self.animating;
}


@end

